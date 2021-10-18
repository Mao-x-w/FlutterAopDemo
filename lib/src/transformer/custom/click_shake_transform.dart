import '../../transformer/custom/store_utils.dart';
import 'package:kernel/ast.dart';
// ignore: implementation_imports
import 'package:front_end/src/fasta/kernel/internal_ast.dart';

///防抖动
class ClickShakeTransform extends RecursiveVisitor<void> {

  final List<String> _blackListName = <String>['onTap','onTapDown','onDown'];
  final String _blackMapName = 'operateBlackListMap';

  @override
  void visitProcedure(Procedure node) {
    super.visitProcedure(node);
    if(node.kind == ProcedureKind.Method && node.name.name.contains('invokeCallback')){
      if(node.parent is Class){
        final Class cls = node.parent;
        if(cls.name == 'GestureRecognizer'){
          bool existField = false;
          for(Field f in cls.fields){
            if(f.name.name == _blackMapName){
              existField = true;
            }
          }
          if(!existField){
            //add operateBlackListMap field
            final List<MapEntry> entries = <MapEntry>[];
            for(String blackName in _blackListName){
              entries.add(MapEntry(StringLiteral(blackName), IntJudgment(0,'0')));
            }
            final Field blockMapField = Field(Name(_blackMapName),type: InterfaceType.byReference(Stores.mapReference, Nullability.nonNullable,<DartType>[]),initializer:
            MapLiteral(entries,keyType: InterfaceType.byReference(Stores.stringReference, Nullability.legacy, <DartType>[]),valueType:
            InterfaceType.byReference(Stores.intReference, Nullability.legacy, <DartType>[])),isFinal: true);
            cls.fields.add(blockMapField);

            final FunctionNode functionNode = node.function;
            final Block block = functionNode.body;

            final VariableDeclaration nameVariable = functionNode.positionalParameters[0];
            final VariableGetImpl nameVariableGet =  VariableGetImpl(nameVariable,null,null,forNullGuardedAccess: false);

            final MethodInvocation methodInvocation = MethodInvocation(PropertyGet(ThisExpression(),Name(_blackMapName)),Name('containsKey'),ArgumentsImpl(<Expression>[nameVariableGet]),null);//Reference to dart:core::Map::@methods::containsKey
            final List<Statement> addStatements = <Statement>[];
            final Block addBlock = Block(addStatements);
            final IfStatement ifStatement = IfStatement(methodInvocation,addBlock,null);
            block.statements.insert(1, ifStatement);//插入到assert之后


            final VariableDeclarationImpl preTimeVariable = VariableDeclarationImpl('preOperateTime',0,initializer: MethodInvocation(PropertyGet(ThisExpression(),Name(_blackMapName)),
                Name('[]'),Arguments(<Expression>[VariableGetImpl(nameVariable,null,null,forNullGuardedAccess: false)])));
            addStatements.add(preTimeVariable);

            final PropertyGet propertyGet = PropertyGet(ConstructorInvocation(Stores.dateTimeNowConstructor,ArgumentsImpl(<Expression>[])),Name('millisecondsSinceEpoch'));
            final Name name = Name('-');
            final Arguments arguments = Arguments(<Expression>[VariableGetImpl(preTimeVariable,null,null,forNullGuardedAccess: false)]);
            final VariableDeclarationImpl difTimeVariable = VariableDeclarationImpl('difTime',0,initializer:
            MethodInvocation(propertyGet,name,arguments),
            );
            addStatements.add(difTimeVariable);

            //blackListMap[name] = DateTime.now().millisecondsSinceEpoch;
            final MethodInvocation methodInvocation1 = MethodInvocation(PropertyGet(ThisExpression(),Name(_blackMapName)),Name('[]='),Arguments(<Expression>[VariableGetImpl(nameVariable,null,null,forNullGuardedAccess: false),propertyGet]),
                null);//Reference to dart:core::Map::@methods::[]=
            final ExpressionStatement expressionStatement = ExpressionStatement(methodInvocation1);
            addStatements.add(expressionStatement);

//          if ((difTime > 100) && (difTime < intervalTime)) {
//            return;
//          }
            final MethodInvocation leftMethodInvocation = MethodInvocation(VariableGetImpl(difTimeVariable,null,null,forNullGuardedAccess: false),Name('>'),Arguments(<Expression>[IntJudgment(100,'100')]));
            final MethodInvocation rightMethodInvocation = MethodInvocation(VariableGetImpl(difTimeVariable,null,null,forNullGuardedAccess: false),Name('<'),Arguments(<Expression>[IntJudgment(200,'200')]));
            final LogicalExpression logicalExpression = LogicalExpression(leftMethodInvocation,'&&',rightMethodInvocation);
            final IfStatement ifStatement1 = IfStatement(logicalExpression,Block(<Statement>[ReturnStatementImpl(false,NullLiteral())]),null);
            addStatements.add(ifStatement1);
          }
        }
      }
    }
     if(node.kind  == ProcedureKind.Method){
      final List<Expression> annotations = node.annotations;
      for(Expression annotation in annotations){
        if(annotation is ConstructorInvocation){
          final ConstructorInvocation constructorInvocation = annotation;
          final Class cls = constructorInvocation?.targetReference?.node?.parent;
          if(cls.name == 'ClickShake'){
            int intervalTime;
            String tips;
            if(constructorInvocation.arguments.named.isNotEmpty){
              for(NamedExpression namedExpression in constructorInvocation.arguments.named){
                if(namedExpression.name == 'intervalTime'){
                  final IntJudgment intJudgment = namedExpression?.value;
                  intervalTime = intJudgment?.value;
                }else if(namedExpression.name == 'tips'){
                  final StringLiteral stringLiteral = namedExpression?.value;
                  tips = stringLiteral?.value;
                }
             }
            }
            //构造插入的代码块
            final StaticInvocation isDoubleClickInvocation = StaticInvocation.byReference(Stores.isDoubleClickReference, ArgumentsImpl(<Expression>[IntJudgment(intervalTime??200,'${intervalTime??200}'),StringLiteral(tips??'')]));
            final Block thenReturnBlock = Block(<Statement>[ReturnStatementImpl(false)]);
            final IfStatement ifStatement = IfStatement(isDoubleClickInvocation,thenReturnBlock,null);
            final Statement body = node.function.body;
            if(body is Block){
              final Block blockBody = body;
              blockBody.statements.insert(0, ifStatement);
            }else{
              final Block newBlock = Block(<Statement>[ifStatement,body]);
              node.function.body = newBlock;
            }
            break;
          }
        }
      }
    }
  }
}
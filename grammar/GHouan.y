%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}

%token ABSTRACT
%token BOOLEAN BREAK BYTE BYVALUE
%token CASE CAST CATCH CHAR CONST CONTINUE
%token DEFAULT DO DOUBLE
%token ELSE EXTENDS
%token FINAL FINALLY FLOAT FOR FUTURE
%token GENERIC GOTO
%token IF IMPLEMENTS USING INNER INSTANCEOF INT INTERFACE
%token LONG LOOP
%token NATIVE NEW JNULL
%token OPERATOR OUTER
%token PACKAGE PRIVATE PROTECTED PUBLIC
%token REST RETURN
%token SHORT STATIC SUPER SWITCH SYNCHRONIZED SELF
%token THIS THROW THROWS TRANSIENT TRY
%token VOID VOLATILE
%token WHILE
%token OP_INC OP_DEC
%token OP_SHL OP_SHR OP_SHRR
%token OP_GE OP_LE OP_EQ OP_NE
%token OP_LAND OP_LOR
%token OP_DIM
%token ASS_MUL ASS_DIV ASS_MOD ASS_ADD ASS_SUB
%token ASS_SHL ASS_SHR ASS_SHRR ASS_AND ASS_XOR ASS_OR
%token IDENTIFIER LITERAL BOOLLIT
%token FN REFLEX EMIT
%token AGENT OBJECT TRAIT DIE
%token VAL VAR

%start CompilationUnit

%%

TypeSpecifier
	: TypeName
	| TypeName Dims
	;

TypeName
	: PrimitiveType
	| QualifiedName
	;

ObjectNameList
        : QualifiedName
        | ObjectNameList ',' QualifiedName
	;

PrimitiveType
	: BOOLEAN
	| CHAR
	| BYTE
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| VOID
	;

Semicolon
	: ';'
        ;

/******************************/
CompilationUnit
	: PackageDeclaration UsingDeclarations  TypeDeclarations
	| PackageDeclaration                    TypeDeclarations
	|                    UsingDeclarations  TypeDeclarations
	|                                       TypeDeclarations
	;

PackageDeclaration
	: PACKAGE QualifiedName Semicolon
	;

TypeDeclarations
	: TypeDeclarationOptSemi
	| TypeDeclarations TypeDeclarationOptSemi
	;

TypeDeclarationOptSemi
        : TypeDeclaration
        | TypeDeclaration Semicolon
        ;

UsingDeclarations
	: UsingDeclaration
	| UsingDeclarations UsingDeclaration
	;

UsingDeclaration
	: USING QualifiedName Semicolon
	| USING QualifiedName '.' '*' Semicolon
	;

QualifiedName
	: IDENTIFIER
	| QualifiedName '.' IDENTIFIER
	;


TypeDeclaration
	: ObjectHeader '{' FieldDeclarations      '}'
	| ObjectHeader '{'                        '}'
	| AGENT        '{' AgentFieldDeclarations '}'
	| AGENT        '{'                        '}'
	;

ObjectHeader
	: Modifiers ClassWord IDENTIFIER Extends Interfaces
	| Modifiers ClassWord IDENTIFIER Extends
	| Modifiers ClassWord IDENTIFIER         Interfaces
	|           ClassWord IDENTIFIER Extends Interfaces
	| Modifiers ClassWord IDENTIFIER
	|           ClassWord IDENTIFIER Extends
	|           ClassWord IDENTIFIER         Interfaces
	|           ClassWord IDENTIFIER
	;

Modifiers
	: Modifier
	| Modifiers Modifier
	;

Modifier
	: ABSTRACT
	| FINAL
	| PUBLIC
	| PRIVATE
	| STATIC
	| VOLATILE
	;

ClassWord
	: OBJECT
	| TRAIT
	;

Extends
	: EXTENDS     TypeName
	| EXTENDS ',' TypeName
	;

Interfaces
	: IMPLEMENTS ObjectNameList
	;


FieldDeclarations
	: FieldDeclarationOptSemi
        | FieldDeclarations FieldDeclarationOptSemi
	;

FieldDeclarationOptSemi
        : FieldDeclaration
        | FieldDeclaration Semicolon
        ;

FieldDeclaration
	: FieldVariableDeclaration 
	| MethodDeclaration
	| ConstructorDeclaration
	| StaticInitializer
        | NonStaticInitializer
        | TypeDeclaration
	;

FieldVariableDeclaration
	: Modifiers TypeSpecifier VariableDeclarators
	|           TypeSpecifier VariableDeclarators
	;

VariableDeclarators
	: VariableDeclarator
	| VariableDeclarators ',' VariableDeclarator
	;

VariableDeclarator
	: DeclaratorName
	| DeclaratorName '=' VariableInitializer
	;

VariableInitializer
	: Expression
	| '{' '}'
        | '{' ArrayInitializers '}'
        ;

ArrayInitializers
	: VariableInitializer
	| ArrayInitializers ',' VariableInitializer
	| ArrayInitializers ','
	;

MethodDeclaration
	: Modifiers TypeSpecifier MethodDeclarator Throws MethodBody
	| Modifiers TypeSpecifier MethodDeclarator        MethodBody
	|           TypeSpecifier MethodDeclarator Throws MethodBody
	|           TypeSpecifier MethodDeclarator        MethodBody
	;

MethodDeclarator
	: DeclaratorName '(' ParameterList ')'
	| DeclaratorName '(' ')'
	| MethodDeclarator OP_DIM
	;

ParameterList
	: Parameter
	| ParameterList ',' Parameter
	;

Parameter
	: TypeSpecifier DeclaratorName
        | FINAL TypeSpecifier DeclaratorName
	;

DeclaratorName
	: IDENTIFIER
        | DeclaratorName OP_DIM
        ;

Throws
	: THROWS ObjectNameList
	;

MethodBody
	: Block
	| ';'
	;

ConstructorDeclaration
	: Modifiers ConstructorDeclarator Throws Block
	| Modifiers ConstructorDeclarator        Block
	|           ConstructorDeclarator Throws Block
	|           ConstructorDeclarator        Block
	;

ConstructorDeclarator
	: IDENTIFIER '(' ParameterList ')'
	| IDENTIFIER '(' ')'
	;

StaticInitializer
	: STATIC Block
	;

NonStaticInitializer
        : Block
        ;

Block
	: '{' LocalVariableDeclarationsAndStatements '}'
	| '{' '}'
        ;

LocalVariableDeclarationsAndStatements
	: LocalVariableDeclarationOrStatement
	| LocalVariableDeclarationsAndStatements LocalVariableDeclarationOrStatement
	;

LocalVariableDeclarationOrStatement
	: LocalVariableDeclarationStatement
	| Statement
	;

LocalVariableDeclarationStatement
	: TypeSpecifier VariableDeclarators ';'
        | FINAL TypeSpecifier VariableDeclarators ';'
	;

Statement
	: EmptyStatement
	| LabelStatement
	| ExpressionStatement ';'
        | SelectionStatement
        | IterationStatement
	| JumpStatement
	| GuardingStatement
	| Block
	;

EmptyStatement
	: ';'
        ;

LabelStatement
	: IDENTIFIER ':'
        | CASE ConstantExpression ':'
	| DEFAULT ':'
        ;

ExpressionStatement
	: Expression
	;

SelectionStatement
	: IF '(' Expression ')' Statement
        | IF '(' Expression ')' Statement ELSE Statement
        | SWITCH '(' Expression ')' Block
        ;

IterationStatement
	: WHILE '(' Expression ')' Statement
	| DO Statement WHILE '(' Expression ')' ';'
	| FOR '(' ForInit ForExpr ForIncr ')' Statement
	| FOR '(' ForInit ForExpr         ')' Statement
	;

ForInit
	: ExpressionStatements ';'
	| LocalVariableDeclarationStatement
	| ';'
	;

ForExpr
	: Expression ';'
	| ';'
	;

ForIncr
	: ExpressionStatements
	;

ExpressionStatements
	: ExpressionStatement
	| ExpressionStatements ',' ExpressionStatement
	;

JumpStatement
	: BREAK IDENTIFIER ';'
	| BREAK            ';'
        | CONTINUE IDENTIFIER ';'
	| CONTINUE            ';'
	| RETURN Expression ';'
	| RETURN            ';'
	| THROW Expression ';'
	;

GuardingStatement
	: SYNCHRONIZED '(' Expression ')' Statement
	| TRY Block Finally
	| TRY Block Catches
	| TRY Block Catches Finally
	;

Catches
	: Catch
	| Catches Catch
	;

Catch
	: CatchHeader Block
	;

CatchHeader
	: CATCH '(' TypeSpecifier IDENTIFIER ')'
	| CATCH '(' TypeSpecifier ')'
	;

Finally
	: FINALLY Block
	;

PrimaryExpression
	: QualifiedName
	| NotJustName
	;

NotJustName
	: SpecialName
	| NewAllocationExpression
	| ComplexPrimary
	;

ComplexPrimary
	: '(' Expression ')'
	| ComplexPrimaryNoParenthesis
	;

ComplexPrimaryNoParenthesis
	: LITERAL
	| BOOLLIT
	| ArrayAccess
	| FieldAccess
	| MethodCall
	;

ArrayAccess
	: QualifiedName '[' Expression ']'
	| ComplexPrimary '[' Expression ']'
	;

FieldAccess
	: NotJustName '.' IDENTIFIER
	| RealPostfixExpression '.' IDENTIFIER
        | QualifiedName '.' THIS
        | QualifiedName '.' OBJECT
        | PrimitiveType '.' OBJECT
	;

MethodCall
	: MethodAccess '(' ArgumentList ')'
	| MethodAccess '(' ')'
	;

MethodAccess
	: ComplexPrimaryNoParenthesis
	| SpecialName
	| QualifiedName
	;

SpecialName
	: THIS
	| SUPER
	| JNULL
	;

ArgumentList
	: Expression
	| ArgumentList ',' Expression
	;

NewAllocationExpression
        : PlainNewAllocationExpression
        | QualifiedName '.' PlainNewAllocationExpression
        ;

PlainNewAllocationExpression
    	: ArrayAllocationExpression
    	| ClassAllocationExpression
    	| ArrayAllocationExpression '{' '}'
    	| ClassAllocationExpression '{' '}'
    	| ArrayAllocationExpression '{' ArrayInitializers '}'
    	| ClassAllocationExpression '{' FieldDeclarations '}'
    	;

ClassAllocationExpression
	: NEW TypeName '(' ArgumentList ')'
	| NEW TypeName '('              ')'
        ;

ArrayAllocationExpression
	: NEW TypeName DimExprs Dims
	| NEW TypeName DimExprs
        | NEW TypeName Dims
	;

DimExprs
	: DimExpr
	| DimExprs DimExpr
	;

DimExpr
	: '[' Expression ']'
	;

Dims
	: OP_DIM
	| Dims OP_DIM
	;

PostfixExpression
	: PrimaryExpression
	| RealPostfixExpression
	;

RealPostfixExpression
	: PostfixExpression OP_INC
	| PostfixExpression OP_DEC
	;

UnaryExpression
	: OP_INC UnaryExpression
	| OP_DEC UnaryExpression
	| ArithmeticUnaryOperator CastExpression
	| LogicalUnaryExpression
	;

LogicalUnaryExpression
	: PostfixExpression
	| LogicalUnaryOperator UnaryExpression
	;

LogicalUnaryOperator
	: '~'
	| '!'
	;

ArithmeticUnaryOperator
	: '+'
	| '-'
	;

CastExpression
	: UnaryExpression
	| '(' PrimitiveTypeExpression ')' CastExpression
	| '(' ClassTypeExpression ')' CastExpression
	| '(' Expression ')' LogicalUnaryExpression
	;

PrimitiveTypeExpression
	: PrimitiveType
        | PrimitiveType Dims
        ;

ClassTypeExpression
	: QualifiedName Dims
        ;

MultiplicativeExpression
	: CastExpression
	| MultiplicativeExpression '*' CastExpression
	| MultiplicativeExpression '/' CastExpression
	| MultiplicativeExpression '%' CastExpression
	;

AdditiveExpression
	: MultiplicativeExpression
        | AdditiveExpression '+' MultiplicativeExpression
	| AdditiveExpression '-' MultiplicativeExpression
        ;

ShiftExpression
	: AdditiveExpression
        | ShiftExpression OP_SHL AdditiveExpression
        | ShiftExpression OP_SHR AdditiveExpression
        | ShiftExpression OP_SHRR AdditiveExpression
	;

RelationalExpression
	: ShiftExpression
        | RelationalExpression '<' ShiftExpression
	| RelationalExpression '>' ShiftExpression
	| RelationalExpression OP_LE ShiftExpression
	| RelationalExpression OP_GE ShiftExpression
	| RelationalExpression INSTANCEOF TypeSpecifier
	;

EqualityExpression
	: RelationalExpression
        | EqualityExpression OP_EQ RelationalExpression
        | EqualityExpression OP_NE RelationalExpression
        ;

AndExpression
	: EqualityExpression
        | AndExpression '&' EqualityExpression
        ;

ExclusiveOrExpression
	: AndExpression
	| ExclusiveOrExpression '^' AndExpression
	;

InclusiveOrExpression
	: ExclusiveOrExpression
	| InclusiveOrExpression '|' ExclusiveOrExpression
	;

ConditionalAndExpression
	: InclusiveOrExpression
	| ConditionalAndExpression OP_LAND InclusiveOrExpression
	;

ConditionalOrExpression
	: ConditionalAndExpression
	| ConditionalOrExpression OP_LOR ConditionalAndExpression
	;

ConditionalExpression
	: ConditionalOrExpression
	| ConditionalOrExpression '?' Expression ':' ConditionalExpression
	;

AssignmentExpression
	: ConditionalExpression
	| UnaryExpression AssignmentOperator AssignmentExpression
	;

AssignmentOperator
	: '='
	| ASS_MUL
	| ASS_DIV
	| ASS_MOD
	| ASS_ADD
	| ASS_SUB
	| ASS_SHL
	| ASS_SHR
	| ASS_SHRR
	| ASS_AND
	| ASS_XOR
	| ASS_OR
	;

Expression
	: AssignmentExpression
        ;

ConstantExpression
	: ConditionalExpression
	;


AgentFieldDeclarations
	: AgentFieldDeclarationOptSemi
        | AgentFieldDeclarations AgentFieldDeclarationOptSemi
	;

AgentFieldDeclarationOptSemi
        : AgentFieldDeclaration
        | AgentFieldDeclaration Semicolon
        ;

AgentFieldDeclaration
	: AgentPropertyDeclaration 
	| AgentReflexDeclaration
	| AgentFunctionDeclaration
        ;

AgentPropertyDeclaration
	: ValueModifier VariableDeclarators
	;

ValueModifier
	: VAL
	| VAR
	;
VariableDeclarators
	: VariableDeclarator
	| VariableDeclarators ',' VariableDeclarator
	;

VariableDeclarator
	: DeclaratorName
	| DeclaratorName '=' VariableInitializer
	| DeclaratorName ':' TypeSpecifier
	| DeclaratorName ':' TypeSpecifier '=' VariableInitializer
	;

AgentReflexDeclaration
	: DeclaratorName ':' REFLEX '(' AgentParameterList ')' '-''>' '(' AgentParameterList ')' MethodBody
	;
AgentFunctionDeclaration
	: DeclaratorName ':' FN '(' AgentParameterList ')' '-''>' '(' AgentParameterList ')' MethodBody
	;

AgentParameterList
	: AgentParameter
	| AgentParameterList ',' AgentParameter
	| /*nothing*/
	;

AgentParameter
	: VariableDeclarator 
	;

%%

int main(int argc, char **argv) {
	char* output_file_name;
	char* input_file_name;
	extern FILE* yyin;
	extern FILE* yyout;

	// Usage String
	char* usage = "%s, usage [infile] [outfile] \n";
	if ((argc > 3) || (1 == argc)) {
		fprintf(stderr, usage, argv[0]);
		exit(1);
	}
	input_file_name = argv[1];
	if (argc = 3) {
		output_file_name = argv[2];
	} else {
		output_file_name = "GHouan_default.out";
	}
	
	//get input file handler
	yyin = fopen(input_file_name, "r");
	if (NULL == yyin) {
		fprintf(stderr, "%s: cannot open file %s\n", argv[0], input_file_name);
		exit(1);
	}
	//get output file handler
	yyout = fopen(output_file_name, "w");
	if (NULL == yyout) {
		fprintf(stderr, "%s: cannot create file %s\n", argv[0], output_file_name);
		exit(1);
	}

	/* yyparse */
	yyparse();
	//end_file();
	exit(0);
}

int yyerror(void){}

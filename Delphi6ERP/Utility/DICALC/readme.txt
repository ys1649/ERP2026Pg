Calculator

//.DESC  Simple calculator for standard expressions
//.AUTOR Ivlev M.Dmitry
// Email: Dimon@Diogen.nstu.nsk.su

It's simple line interpreteur which can to be used for make calculator or
for inner use. This parcer can be easelly extends with one argument functions
like Ln(), Sin() and so on and also can store temporary results in dynamic
variables using them late. Parcer understand numbers in format C, Pascal 
and Assembler and also degrees in special format. For get/set value of 
variables and call functions interpreteur uses callback function call.
Here also TCalculator component used line interpreteur and handle 
dynamic variables and functions access.

Syntax:
=======
  0xABCD, 0ABCDh, $ABCD - Hex number
  0b0101, 01010b,       - Binary number
  90`15`2               - Degree (degree`min`sec)
  Operators by priorities:
    {  7} () (BRACES)
    {  6} ** (POWER),
    {  5} ~ (INVERSE), ! (NOT),
    {  4} * (MUL), / (DIV), % (MOD), %% (PERSENT),
    {  3} + (ADD), - (SUB),
    {  2} < (LT), <= (LE), == (EQ), <> != (NE), >= (GE), > (GT),
    {  1} | (OR), ^ (XOR), & (AND)
    {  0} = (Assign value)


The module consists

{ Default calculator callback proc }
function DefCalcProc(ctype: TCalcCBType; const S: String;
  var V: Double): Boolean;

{ Degree convertation functions }
function DegreeToStr(Angle: Extended): String;
function StrToDegree(const S: String): Extended;

{ Calculate functions }
function StrCalculate(Buff: PChar; var R: Double; Proc: TCalcCBProc): Boolean;
function Calculate(const Formula: String; var R: Double; Proc: TCalcCBProc): Boolean;

types
  ECalculate = class(Exception); 
  TCalcCBType = (ctGetValue, ctSetValue, ctFunction);
  TCalcCBProc = function(ctype: TCalcCBType; const S: String; var Value: Double): Boolean;
  TCalculator = class(TPersistent)
  protected
    function  Callback(ctype: TCalcCBType;
              const Name: String; var Res: Double): Boolean; virtual;
  public
    function  NameOf(Index: Word): String;
    procedure ClearVars;
  published
    property Expression: String Read FExpression Write FExpression;
    property Result: Double Read GetResult;
    property Vars[const Name: String]: Double Read GetVar Write SetVar;
  end;

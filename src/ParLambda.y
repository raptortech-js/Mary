-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParLambda
  ( happyError
  , myLexer
  , pExpression1
  , pExpression2
  , pExpression3
  , pExpression
  ) where

import Prelude

import qualified AbsLambda
import LexLambda

}

%name pExpression1 Expression1
%name pExpression2 Expression2
%name pExpression3 Expression3
%name pExpression Expression
-- no lexer declaration
%monad { Err } { (>>=) } { return }
%tokentype {Token}
%token
  '(' { PT _ (TS _ 1) }
  ')' { PT _ (TS _ 2) }
  '+' { PT _ (TS _ 3) }
  '.' { PT _ (TS _ 4) }
  'and' { PT _ (TS _ 5) }
  'false' { PT _ (TS _ 6) }
  'if' { PT _ (TS _ 7) }
  'let' { PT _ (TS _ 8) }
  'not' { PT _ (TS _ 9) }
  'or' { PT _ (TS _ 10) }
  'true' { PT _ (TS _ 11) }
  '~' { PT _ (TS _ 12) }
  L_Ident  { PT _ (TV $$) }
  L_integ  { PT _ (TI $$) }

%%

Ident :: { AbsLambda.Ident }
Ident  : L_Ident { AbsLambda.Ident $1 }

Integer :: { Integer }
Integer  : L_integ  { (read $1) :: Integer }

Expression1 :: { AbsLambda.Expression }
Expression1 : '~' Ident '.' Expression { AbsLambda.ELambda $2 $4 }
            | 'if' Expression Expression Expression { AbsLambda.EIf $2 $3 $4 }
            | 'and' Expression Expression { AbsLambda.EAnd $2 $3 }
            | 'or' Expression Expression { AbsLambda.EOr $2 $3 }
            | '+' Expression Expression { AbsLambda.EPlus $2 $3 }
            | Expression2 { $1 }

Expression2 :: { AbsLambda.Expression }
Expression2 : 'let' Ident Expression Expression { AbsLambda.ELet $2 $3 $4 }
            | 'not' Expression { AbsLambda.ENot $2 }
            | Expression Expression { AbsLambda.ECall $1 $2 }
            | Expression3 { $1 }

Expression3 :: { AbsLambda.Expression }
Expression3 : 'true' { AbsLambda.ETrue }
            | 'false' { AbsLambda.EFalse }
            | Integer { AbsLambda.ENum $1 }
            | Ident { AbsLambda.EVar $1 }
            | '(' Expression ')' { $2 }

Expression :: { AbsLambda.Expression }
Expression : Expression1 { $1 }
{

type Err = Either String

happyError :: [Token] -> Err a
happyError ts = Left $
  "syntax error at " ++ tokenPos ts ++
  case ts of
    []      -> []
    [Err _] -> " due to lexer error"
    t:_     -> " before `" ++ (prToken t) ++ "'"

myLexer :: String -> [Token]
myLexer = tokens

}

{

-- Detalhes dessa implementação podem ser encontrados em:
-- https://www.haskell.org/happy/doc/html/sec-using.html

module Parser where
import Data.Char

}

%name parser
%tokentype { Token }
%error { parseError }

%token 
  true		{ TokenTrue }
  num		{ TokenNum $$ }
  '+'		{ TokenPlus }
  '('   { TokenOB }
  ')'   { TokenCB }
  ','   { TokenV }
  tp  { TokenPrimeiro }
  ts  { TokenSegundo }

%%

Exp	: true 		{ BTrue }    
        | num		{ Num $1 }
        | Exp '+' Exp	{ Add $1 $3 }
        | '(' Exp ',' Exp ')' { Pair $2 $4 }
        | tp Exp { RetornaP $2 }
        | ts Exp { RetornaS $2 }


-- Inicio da codificação do Lexer
{

parseError :: [Token] -> a
parseError _ = error "Syntax error: sequência de caracteres inválida!"

-- Árvore de sintaxe abstrata (desenvolvida em aula) 
data Expr = BTrue
          | BFalse
          | Num Int
          | Add Expr Expr
          | And Expr Expr
          | If Expr Expr Expr
          | Pair Expr Expr
          | RetornaP Expr
          | RetornaS Expr
          deriving (Show, Eq)

-- Tokens permitidos na linguagem (adicionar outras constantes e operadores)
data Token = TokenTrue
           | TokenFalse
           | TokenNum Int
           | TokenPlus
           | TokenOB
           | TokenCB
           | TokenV
           | TokenPrimeiro
           | TokenSegundo
           deriving Show

-- Analisador léxico que 
-- Lê o código e converte em uma lista de tokens
lexer :: String -> [Token]
lexer [] = []
lexer (c:cs)
     | isSpace c = lexer cs
     | isAlpha c = lexBool (c:cs)
     | isDigit c = lexNum (c:cs)
lexer ('+':cs) = TokenPlus : lexer cs
lexer ('(':cs) = TokenOB : lexer cs
lexer (')':cs) = TokenCB : lexer cs
lexer (',':cs) = TokenV : lexer cs
lexer _ = error "Lexical error: caracter inválido!"

-- Lê um token booleano
-- Adicionar a constante false ao final
lexBool cs = case span isAlpha cs of
               ("true", rest) -> TokenTrue : lexer rest
               ("tp", rest) -> TokenPrimeiro : lexer rest
               ("ts", rest) -> TokenSegundo : lexer rest

-- Lê um token numérico 
lexNum cs = case span isDigit cs of
              (num, rest) -> TokenNum (read num) : lexer rest

}



module Interpreter where

import Parser 

-- Definição de tipos
data Ty = TBool
        | TNum 
        | TPair Ty Ty
        deriving Show

-- Função que avalia um passo de execução
step :: Expr -> Maybe Expr
-- S-Add
step (Add (Num n1) (Num n2)) = Just (Num (n1 + n2))
-- S-Add2 
step (Add (Num n) e2) = 
    case (step e2) of
        Just e2' -> Just (Add (Num n) e2')
        Nothing  -> Nothing                        
-- S-Add1
step (Add e1 e2) = 
    case (step e1) of 
        Just e1' -> Just (Add e1' e2)
        Nothing  -> Nothing
-- S-And2
step (And BTrue e2) = Just e2
-- S-And3
step (And BFalse e2) = Just BFalse
-- S-And1
step (And e1 e2) = 
    case (step e1) of 
        Just e1' -> Just (And e1' e2)
        Nothing  -> Nothing
step (If BTrue e1 e2) = Just e1
step (If BFalse e1 e2) = Just e2
step (If e1 e2 e3) = case (step e1) of
                       Just e1' -> Just (If e1' e2 e3)
                       Nothing  -> Nothing
-- Steps novos
step (RetornaP (Pair e1 e2)) = Just e1
step (RetornaS (Pair e1 e2)) = Just e2
step (Pair e1 e2 ) = case (step e1) of
                        Just e' -> case (step e2) of 
                            Just e2'-> Just (Pair e' e2')
                            Nothing -> Nothing
                        Nothing -> Nothing
step e = Just e

-- Função que avalia uma expressão 
-- Até apresentar um resultado ou gerar um erro
eval :: Expr -> Maybe Expr
eval e = case (step e) of 
           Just e' -> if (e == e') then
                        Just e
                      else
                        eval e'
           _ -> error "Semantic error: erro avaliando expressão!" 

-- Função que verifica o tipo de uma expressão
typeof :: Expr -> Maybe Ty 
typeof BTrue = Just TBool
typeof BFalse = Just TBool
typeof (Num _) = Just TNum
typeof (Add e1 e2) = case (typeof e1) of
                       Just TNum -> case (typeof e2) of
                                      Just TNum -> Just TNum
                                      _         -> Nothing -- erro de tipo
                       _         -> Nothing -- erro de tipo
typeof (And e1 e2) = case (typeof e1, typeof e2) of 
                       (Just TBool, Just TBool) -> Just TBool
                       _                        -> Nothing -- erro de tipo
typeof (If e1 e2 e3) = case (typeof e1) of 
                         Just TBool -> case (typeof e2, typeof e3) of 
                                         (Just TBool, Just TBool) -> Just TBool
                                         (Just TNum, Just TNum)   -> Just TNum
                                         _                        -> Nothing -- erro de tipo
                         _          -> Nothing -- erro de tipo
typeof (RetornaP (Pair e1 e2)) = case (typeof e1, typeof e2) of
                                    (Just TNum, Just TNum)        -> Just TNum
                                    (Just TBool, Just TBool)      -> Just TBool
                                    (Just TNum, Just TBool)       -> Just TNum
typeof (RetornaS (Pair e1 e2)) = case (typeof e1, typeof e2) of
                                    (Just TNum, Just TNum)        -> Just TNum
                                    (Just TBool, Just TBool)      -> Just TBool
                                    (Just TNum, Just TBool)       -> Just TNum
typeof (Pair e1 e2) = case (typeof e1) of
                        Just t1 -> case (typeof e2) of
                            Just t2 -> Just (TPair t1 t2)
                            _         -> Nothing -- erro de tipo
                        _         -> Nothing -- erro de tipo

-- Função que faz a verificação de tipos
typecheck :: Expr -> Expr
typecheck e = case (typeof e) of 
                Just _ -> e
                _ -> error "Type error: erro na verificação de tipos!"


-- Lê os códigos e chamar o interpretador
-- A ordem de leitura é da direita para a esquerda
-- Ou seja, o lexer, depois o parser, depois o typecheck...
main = getContents >>= print . eval . typecheck . parser . lexer 

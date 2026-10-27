-- Navn: Alexander Rohde Jakobsen

module Oblig where
import Data.Char

-- ===== 1  Parsing og ASTer =====

-- 1.1  data Ast

data Ast = App Ast Ast | Add Ast Ast | Sub Ast Ast | Mult Ast Ast
  | Div Ast Ast | Val Int | Var String | Lambda String Ast
  deriving (Eq, Show, Read)

-- 1.2  tokenise og parse

tokenise :: String -> [String]
tokenise [] = []
tokenise ('-':'>':xs) = "->" : tokenise xs
tokenise (x:xs)
  | isSpace x = tokenise xs
  | isLower x = atom : tokenise rest
  | isDigit x = num : tokenise left
  | otherwise = [x] : tokenise xs
  where (atom, rest) = span isLower (x:xs)
        (num, left) = span isDigit (x:xs)

parseExpr :: [String] -> (Ast, [String])
parseExpr tokens
  | take 1 rest1 == ["+"] = (Add tree1 tree2, rest2)
  | take 1 rest1 == ["-"] = (Sub tree1 tree2, rest2)
  | otherwise = (tree1, rest1)
  where (tree1, rest1) = parseExpr1 tokens
        (tree2, rest2) = parseExpr (drop 1 rest1)

parseExpr1 :: [String] -> (Ast, [String])
parseExpr1 tokens
  | take 1 rest1 == ["*"] = (Mult tree1 tree2, rest2)
  | take 1 rest1 == [":"] = (Div tree1 tree2, rest2)
  | otherwise = (tree1, rest1)
  where (tree1, rest1) = parseValue tokens
        (tree2, rest2) = parseExpr1 (drop 1 rest1)

parseValue :: [String] -> (Ast, [String])
parseValue (t:rest)
  | all isDigit t = (Val (read t), rest)
  | all isLower t = (Var t, rest)
  | t == "(" = (inner, drop 1 restP)
  | t == "|" = (Lambda (head rest) body, restL)
  | t == "[" = (App tree1 tree2, drop 1 rest2)
  | otherwise = undefined
  where (tree1, rest1) = parseValue rest
        (tree2, rest2) = parseValue rest1
        (inner, restP) = parseExpr rest
        (body, restL) = parseExpr (drop 2 rest)

-- ===== 2  Typeuttrykk og unifikasjon =====

-- 2.1  Uendelig liste med typevariabelnavn "t1", "t2", ...


-- 2.2  data Type

data Type deriving (Show, Eq)

-- 2.3  occursIn

occursIn :: String -> Type -> Bool
occursIn = undefined

-- 2.4  unify (med occurs-check)

type Eqn = (Type, Type)

unify :: [Eqn] -> Type -> Type
unify = undefined

-- ===== 3  Typing =====

-- 3.1  Context (og eventuelt initialContext)

type Context = [(Ast, Type)]

-- 3.2  generateEqns


-- 3.3  typeOf

typeOf :: String -> Type
typeOf = undefined

-- ===== 4  Interaksjon med bruker =====

-- main: t Expr, f filnavn, q

main :: IO ()
main = undefined

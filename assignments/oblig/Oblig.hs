-- Navn: Alexander Rohde Jakobsen & Bashar Mohamad

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

parse :: String -> Ast
parse s = tree
  where (tree, _) = parseExpr (tokenise s)

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
liste :: [String]
liste = ["t" ++ show n | n <- [1::Int ..]]

-- 2.2  data Type
data Type = TVar String | NumT | Arr Type Type
  deriving (Eq)

instance (Show Type) where
  show NumT = "NumT"
  show (TVar x) = x
  show (Arr (Arr x y) b) = "(" ++ show (Arr x y) ++ ")" ++ "->" ++ show b
  show (Arr a b) = show a ++ "->" ++ show b

-- 2.3  occursIn
occursIn :: String -> Type -> Bool
occursIn xs (TVar t) = xs == t
occursIn _ NumT = False
occursIn xs (Arr t u) = occursIn xs t || occursIn xs u

-- 2.3.1 subst
subst :: String -> Type -> Type -> Type
subst xs s (TVar t)
  | xs == t = s
  | otherwise = TVar t
subst _ _ NumT = NumT
subst xs s (Arr t u) =  Arr (subst xs s t) (subst xs s u)

-- 2.4  unify (med occurs-check)
type Eqn = (Type, Type)

unify :: [(Type, Type)] -> String -> Type
unify [(TVar t, r)] t0 | t == t0 = r -- stoppebetingelsen
unify ((TVar t, r) : rest) t0 | t == t0 = unify (rest ++ [(TVar t, r)]) t0 -- rule 1 flytt t = bakerst, med variabel t på venstre side
unify ((l, TVar t) : rest) t0 | t == t0 = unify (rest ++ [(TVar t, l)]) t0 -- rule 1 flytt t = bakerts, med variabel t på høyre side
unify ((TVar x, y) : rest) t0 | not (occursIn x y) = unify [(subst x y l, subst x y r) | (l, r) <- rest] t0 -- rule 2 substitusjon, om det ikke er occurs feil, gå gjennom alle parene i resten av listen, bytt inn verdien og lag nye par etter substutisjon
unify ((Arr a b, Arr c d) : rest) t0 = unify ((a, c) : (b, d) : rest) t0 -- rule 3 dekomponer piler, om et par har piler på begge sider må de endres om til to nye utrykk
unify ((TVar t, TVar r) : rest) t0 | t == r = unify rest t0 -- Johannes regel 1 fjern, irrelevante par fjernes. a = a sier ingenting nytt og gir evig løkke om den faller i regel 4
unify ((y, TVar x) : rest) t0 = unify ((TVar x, y) : rest) t0 -- rule 4 snu, om variabelen er på feil side må den byttes om
unify ((NumT, NumT) : rest) t0 = unify rest t0 -- Johannes regel 1 fjern, alltid sann og dermed sier ingenting nytt
unify _ _ = error "Occurs check error" -- alle andre tilfeller som ikke er en av reglene

-- ===== 3  Typing =====

-- 3.1  Context (og eventuelt initialContext)
type Context = [(Ast, Type)]

-- 3.2  generateEqns
generateEqns :: Context -> Ast -> Type -> [String] -> ([Eqn], [String])

generateEqns ctx (Val n) t names = ([(t, NumT)], names)

generateEqns ctx (Var x) t names = case lookup (Var x) ctx of
  Just tx -> ([(t, tx)], names)
  Nothing -> error "unknown variable"

generateEqns ctx (Add a b) t names = ([(t, NumT)] ++ eqsA ++ eqsB, namesB)
  where (eqsA, namesA) = generateEqns ctx a NumT names
        (eqsB, namesB) = generateEqns ctx b NumT namesA

generateEqns ctx (Sub a b) t names = ([(t, NumT)] ++ eqsA ++ eqsB, namesB)
  where (eqsA, namesA) = generateEqns ctx a NumT names
        (eqsB, namesB) = generateEqns ctx b NumT namesA

generateEqns ctx (Mult a b) t names = ([(t, NumT)] ++ eqsA ++ eqsB, namesB)
  where (eqsA, namesA) = generateEqns ctx a NumT names
        (eqsB, namesB) = generateEqns ctx b NumT namesA

generateEqns ctx (Div a b) t names = ([(t, NumT)] ++ eqsA ++ eqsB, namesB)
  where (eqsA, namesA) = generateEqns ctx a NumT names
        (eqsB, namesB) = generateEqns ctx b NumT namesA

generateEqns ctx (Lambda x body) t (n1:n2:rest) = ([(t, Arr (TVar n1)(TVar n2))] ++ eqsB, namesB)
  where (eqsB, namesB) = generateEqns ((Var x, TVar n1) : ctx) body (TVar n2) rest

generateEqns ctx (App f a) t (n1:rest) = (eqsF ++ eqsA, namesA)
  where (eqsF, namesF) = generateEqns ctx f (Arr (TVar n1) t) rest
        (eqsA, namesA) = generateEqns ctx a (TVar n1) namesF

-- 3.3  typeOf
typeOf :: String -> Type
typeOf s = unify eqs (TVar "t0")
  where (eqs, _) = generateEqns [] (parse s) (TVar "t0") liste

-- ===== 4  Interaksjon med bruker =====

-- main: t Expr, f filnavn, q
main :: IO ()
main =


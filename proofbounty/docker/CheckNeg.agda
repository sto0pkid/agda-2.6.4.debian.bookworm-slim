module CheckNeg where

open import Input.Goal using ( Goal )
open import Input.Proof using ( proof)
open import Relation.Nullary.Negation using (¬_)

verified : ¬ Goal
verified = proof
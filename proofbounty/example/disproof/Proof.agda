module Input.Proof where

open import Input.Goal using ( Goal )
open import Relation.Nullary.Negation using (¬_)

proof : ¬ Goal
proof ()
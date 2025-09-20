module Input.Goal where

open import Relation.Binary.PropositionalEquality using (_≡_; refl)
open import Data.Nat

Goal : Set
Goal = ∀ n → 0 + n ≡ n
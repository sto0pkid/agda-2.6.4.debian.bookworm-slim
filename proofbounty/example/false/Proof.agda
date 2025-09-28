module Input.Proof where
    open import Input.Goal using (Goal; ⊥)
    open import Agda.Builtin.String
    open import Agda.Builtin.Nat

    record R (x : String) : Set₁ where
        field
            foo : Set

    record R' : Set₁ where
        field foo : Set

    open R'

    module X {z : ⊥} (r : R "foo") where open R r using (foo) public
    open X

    test : R "bar" → Set
    proof : Goal
    proof = _ -- this meta is solved to "bar"

    test r = foo {proof} r
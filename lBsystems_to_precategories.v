(** ** lB-systems to precategories.  

by Vladimir Voevodsky, started on Jan. 22, 2015 *)

Unset Automatic Introduction.

Require Export lBsystems.lBsystems_T_fun_Tj_Ttj.
Require Export lBsystems.lBsystems_S_fun.

Require Export lBsystems.lB0systems .

Require Export lCsystems.lC_to_lB0.


(** *** The first construction of the types Mor_from_B *)


(** We first define for Z in an lB-system and m <= ll Z the type
( iterated_sections m Z ) that corresponds to the sections of the projection Z -> ft^m Z 
in the associated lC-system. We do it for non-unital prelBsystems but the only structure that
is actually required is an lBsystem_carrier and an operation of type S_ops_type satisfying
axiom ax0. *)

Lemma iter_sec_inn { BB : prelBsystem_non_unital }
      { m : nat } { Z : BB } ( gt0 : m > 0 ) ( lesm : S m <= ll Z )
      ( s : Tilde_dd ( ftn m Z ) ) : S_dom s Z .
Proof.
  intros.
  unfold S_dom .
  set ( eq := pr2 s : dd s = ftn m Z ) . simpl in eq .
  rewrite eq .
  
  apply ( isabove_X_ftnX gt0 ) .
  apply ( natgehgthtrans _ _ _ lesm ( natgthsn0 _ ) ) .

Defined.

Lemma iter_sec_le { BB : prelBsystem_non_unital }
      { m : nat } { Z : BB } ( gt0 : m > 0 ) ( lesm : S m <= ll Z )
      ( s : Tilde_dd ( ftn m Z ) ) : m <= ll ( S_op s Z ( iter_sec_inn gt0 lesm s ) ) . 
Proof.
  intros.
  rewrite S_ax0 .
  assert ( leint := natgehandminusr _ _ 1 lesm ) . 
  simpl in leint . 
  rewrite natminuseqn in leint .
  exact leint . 

Defined.


Definition iter_sec { BB : prelBsystem_non_unital }
           ( m : nat ) ( Z : BB ) ( le : m <= ll Z ) : UU .
Proof.
  intros until m . set ( S := @S_op BB ) . set ( sax0 := @S_ax0 BB ) . 
  induction m as [ | m IHm ] .
  intros. exact unit .

  intros Z le .
  destruct ( natgehchoice _ _ ( natgehn0 m ) ) as [ gt0 | eq0 ] . 
  set ( inn := iter_sec_inn gt0 le ) .
  set ( le' := iter_sec_le gt0 le ) . 
  exact ( total2 ( fun s : Tilde_dd ( ftn m Z ) => IHm ( S s Z ( inn s ) ) (le' s) ) ) .

  exact ( Tilde_dd Z ) . 

Defined.


(* Definition iter_sec_m_eq_sn { BB : prelBsystem_non_unital }
           { m n : nat } ( eq : m = S n )
           ( Z : BB ) ( lem : m <= ll Z ) ( lesn : S n <= ll Z ) :
  iter_sec m Z lem =
  total2 ( fun s : Tilde_dd ( ftn m Z ) => iter_sec n ( S s Z ( inn s ) *)


(** We now define morphisms X --> Y as iterated sections of the projection Tprod X Y --> X *)


Definition Mor_from_B { BB : lB0system_non_unital } ( X Y : BB ) : UU .
Proof.
  intros.
  refine ( iter_sec ( ll Y ) ( Tprod X Y ) _ ) .
  rewrite ll_Tprod . 
  apply natlehmplusnm . 

Defined.


(** Here is another definition of morphisms that defines them together with the corresponding
operation f_star *)


Definition Mor_and_fstar { BB : lB0system_non_unital }
           ( X1 : BB ) ( n : nat ) ( A : BB ) ( eq : ll A = n ) : 
  total2 ( fun Mor_X1_A : UU =>
             forall f : Mor_X1_A ,
               ltower_fun ( ltower_over A ) ( ltower_over X1 ) ) . 
Proof .
  intros until n . induction n as [ | n IHn ] . 
  intros . 
  split with unit .

  intro .
  exact ( Tj_fun ( @isoverll0 BB _ eq X1 ) ) . 

  intros .
  assert ( eqft : ll ( ft A ) = n ) . rewrite ll_ft . rewrite eq . simpl . rewrite natminuseqn .
  apply idpath .

  set ( Mor_X1_ftA := pr1 ( IHn ( ft A ) eqft ) ) .
  set ( Mor_X1_A :=
          total2 ( fun ftf : Mor_X1_ftA =>
                     Tilde_dd ( pocto ( ( pr2 ( IHn ( ft A ) eqft ) ftf ) ( X_over_ftX A ) ) ) ) ) .
  split with Mor_X1_A . 

  intro f .
  set ( ftf := pr1 f : Mor_X1_ftA ) .
  set ( s_f := pr1 ( pr2 f ) : Tilde BB ) .
  set ( ftf_star := pr2 ( IHn ( ft A ) eqft ) ftf :
                      ltower_fun ( ltower_over ( ft A ) ) ( ltower_over X1 ) ) .
  set ( ftf_star_A := pocto ( ftf_star ( X_over_ftX A ) : ltower_over X1 ) ) .
  set ( eq_s_f := pr2 ( pr2 f ) : dd ( s_f ) = ftf_star_A ) . 
  assert ( fun1 : ltower_fun ( ltower_over A ) ( ltower_over ftf_star_A ) ) .
  apply ( ltower_fun_second ftf_star ( X_over_ftX A ) ) .

  assert ( fun2 : ltower_fun ( ltower_over ftf_star_A ) ( ltower_over ( ft ftf_star_A ) ) ) . 
  rewrite <- eq_s_f .
  apply ( S_fun s_f ) .

  assert ( gt0 : ll (ftf_star (X_over_ftX A)) > 0 ) .
  rewrite (@ll_ltower_fun (pltower_over ( ft A ) )).
  change ( ll (X_over_ftX A) > 0 ) . 
  rewrite ll_X_over_ftX . 
  apply idpath . 

  rewrite eq . apply natgthsn0 .
  
  assert ( eq' : ft ftf_star_A = X1 ) .
  unfold ftf_star_A .
  rewrite ft_pocto .
  assert ( eq1 : ft (ftf_star (X_over_ftX A)) = X_over_X X1 ) . 
  assert ( eq2 : ll ( ft (ftf_star (X_over_ftX A)) ) = 0 ) .
  rewrite ll_ft . 
  rewrite (@ll_ltower_fun (pltower_over (ft A))). 
  change ( ll (X_over_ftX A) - 1 = 0 ) . 
  rewrite ll_X_over_ftX . 
  apply idpath . 

  rewrite eq . apply natgthsn0 .

  apply ( @noparts_ispointed  ( pltower_over _ ) _ _ eq2 ( ll_X_over_X X1 ) ) . 

  rewrite eq1 .
  apply idpath . 

  apply gt0 . 

  set ( fun12 := ltower_funcomp fun1 fun2 ) .
  rewrite eq' in fun12 . 
  exact fun12 . 

Defined.




(** We now start proving the comparison theorem showing that for lB0-systems of the form
lB0_from_C CC our construction Mor_from_B recovers the morphisms in CC. *)



(** A construction of a function from iterated_sections to morphisms *)

Definition iter_sec_to_mor { CC : lCsystem } ( m : nat ) ( Z : CC ) ( le : m <= ll Z )
           ( itrs : @iter_sec ( lB0_from_C CC ) m Z le ) : ftn m Z --> Z .
Proof.
  intros until m . 
  induction m . 
  intros . 
  apply ( identity Z ) .

  intros . 
  simpl in itrs . 
  destruct (natgehchoice m 0 (natgehn0 m)) as [ gt0 | eq0 ] .

  set ( inn := (@iter_sec_inn ( lB0_from_C CC ) _ _ gt0 le ( pr1 itrs ))).
  set ( le' := (@iter_sec_le ( lB0_from_C CC ) _ _ gt0 le ( pr1 itrs))).
  assert ( s1 := IHm (@S_op ( lB0_from_C CC ) ( pr1 itrs ) Z inn) le' ( pr2 itrs ) ) . 

  assert ( qn_from_S : @S_op ( lB0_from_C CC ) (pr1 itrs) Z inn --> Z ) .  
  unfold S_op.
  simpl .
  unfold S_from_C .
  exact ( qn (mor_to_pr2
                (dd_from_C (Tilde_dd_pr1 (pr1 itrs)))
                (Ob_tilde_over_to_mor_to (dd_from_C (Tilde_dd_pr1 (pr1 itrs)))
                                         (Tilde_from_C_to_Ob_tilde_over (Tilde_dd_pr1 (pr1 itrs)))))
             (ll Z - ll (dd (Tilde_dd_pr1 (pr1 itrs)))) 
             (natminuslehn (ll Z) (ll (dd (Tilde_dd_pr1 (pr1 itrs)))))
             (! isabove_to_isover inn) ) .
  
  
  

Definition Mor_lB0_from_C_to_Mor { CC : lCsystem } ( X Y : CC )
           ( f : @Mor_from_B ( lB0_from_C CC ) X Y ) : X --> Y . 
Proof .
  intros . 





  

(* End of the file lBsystems_to_precategories.v *)
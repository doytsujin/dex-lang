-- Copyright 2021 Google LLC
--
-- Use of this source code is governed by a BSD-style
-- license that can be found in the LICENSE file or at
-- https://developers.google.com/open-source/licenses/bsd

module CoreTraversal (
  ) where

-- type TraversalDef i o m = ( Decl i -> m (Subst i o)
--                           , Expr i -> m (Expr o)
--                           , Atom i -> m (Atom o))

-- substTraversalDef :: (MonadBuilder o m, MonadReader (Subst i o) m)
--                   => TraversalDef i o m
-- substTraversalDef = ( traverseDecl substTraversalDef
--                     , traverseExpr substTraversalDef
--                     , traverseAtom substTraversalDef
--                     )

-- appReduceTraversalDef :: (MonadBuilder o m, MonadReader (Subst i o) m)
--                       => TraversalDef i o m
-- appReduceTraversalDef = ( traverseDecl appReduceTraversalDef
--                         , reduceAppExpr
--                         , traverseAtom appReduceTraversalDef)
--   where
--     reduceAppExpr expr = case expr of
--       App f' x' -> do
--         f <- traverseAtom appReduceTraversalDef f'
--         x <- traverseAtom appReduceTraversalDef x'
--         case f of
--           -- TabVal b body ->
--           --   Atom <$> (dropSub $ extendR (b@>x) $ evalBlockE appReduceTraversalDef body)
--           _ -> return $ App f x
--       _ -> traverseExpr appReduceTraversalDef expr

-- With `def = (traverseExpr def, traverseAtom def)` this should be a no-op
-- traverseDecls :: (MonadBuilder o m, MonadReader (Subst i o) m)
--               => TraversalDef i o m -> Nest Decl i -> m (Nest Decl o, Subst i o)
-- traverseDecls = undefined
-- traverseDecls def decls = liftM swap $ scopedDecls $ traverseDeclsOpen def decls

-- traverseDeclsOpen :: (MonadBuilder o m, MonadReader (Subst i o) m)
--                   => TraversalDef i o m -> Nest Decl i -> m (Subst i o)
-- traverseDeclsOpen = undefined
-- traverseDeclsOpen _ Empty = return mempty
-- traverseDeclsOpen def@(fDecl, _, _) (Nest decl decls) = do
--   env <- fDecl decl
--   env' <- extendR env $ traverseDeclsOpen def decls
--   return (env <> env')

-- traverseDecl :: (MonadBuilder o m, MonadReader (Subst i o) m)
--              => TraversalDef i o m -> Decl i -> m (Subst i o)
-- traverseDecl = undefined
-- -- traverseDecl (_, fExpr, _) decl = case decl of
--   -- Let letAnn b expr -> do
--   --   expr' <- fExpr expr
--   --   case expr' of
--   --     Atom (Var v) -> return $ b @> (Var v)
--   --     _ -> (b@>) <$> emitAnn letAnn expr'

-- traverseBlock :: (MonadBuilder o m, MonadReader (Subst i o) m)
--               => TraversalDef i o m -> (Block i) -> m (Block o)
-- traverseBlock def block = buildScopedBlock $ evalBlockE def block

-- evalBlockE :: (MonadBuilder o m, MonadReader (Subst i o) m)
--               => TraversalDef i o m -> Block i -> m (Atom o)
-- evalBlockE = undefined
-- -- evalBlockE def@(_, fExpr, _) (Block decls result) = do
-- --   env <- traverseDeclsOpen def decls
-- --   resultExpr <- extendR env $ fExpr result
-- --   case resultExpr of
-- --     Atom a -> return a
-- --     _      -> emit resultExpr

-- traverseExpr :: (MonadBuilder o m, MonadReader (Subst i o) m)
--              => TraversalDef i o m -> Expr i -> m (Expr o)
-- traverseExpr def@(_, _, fAtom) expr = case expr of
--   App g x -> App  <$> fAtom g <*> fAtom x
--   Atom x  -> Atom <$> fAtom x
--   Op  op  -> Op   <$> traverse fAtom op
--   Hof hof -> Hof  <$> traverse fAtom hof
--   -- Case e alts ty -> Case <$> fAtom e <*> mapM traverseAlt alts <*> fAtom ty
--   -- where
--   --   traverseAlt (Abs bs body) = do
--   --     bs' <- mapM (mapM fAtom) bs
--   --     buildNAbs bs' \xs -> extendR (newEnv bs' xs) $ evalBlockE def body

-- traverseAtom :: forall i o m . (MonadBuilder o m, MonadReader (Subst i o) m)
--              => TraversalDef i o m -> Atom i -> m (Atom o)
-- traverseAtom = undefined
-- -- traverseAtom def@(_, _, fAtom) atom = case atom of
-- --   Var _ -> substBuilderR atom
-- --   -- Lam (Abs b (WithArrow arr body)) -> do
-- --   --   b' <- mapM fAtom b
-- --   --   buildDepEffLam b'
-- --   --     (\x -> extendR (b'@>x) (substBuilderR arr))
-- --   --     (\x -> extendR (b'@>x) (evalBlockE def body))
-- --   Pi _ -> substBuilderR atom
-- --   Con con -> Con <$> traverse fAtom con
-- --   TC  tc  -> TC  <$> traverse fAtom tc
-- --   Eff _   -> substBuilderR atom
-- --   -- DataCon dataDef params con args -> DataCon dataDef <$>
-- --   --   traverse fAtom params <*> pure con <*> traverse fAtom args
-- --   -- TypeCon dataDef params -> TypeCon dataDef <$> traverse fAtom params
-- --   -- LabeledRow (Ext items rest) -> do
-- --   --   items' <- traverse fAtom items
-- --   --   return $ LabeledRow $ Ext items' rest
-- --   -- Record items -> Record <$> traverse fAtom items
-- --   -- RecordTy (Ext items rest) -> do
-- --   --   items' <- traverse fAtom items
-- --   --   return $ RecordTy $ Ext items' rest
-- --   -- Variant (Ext types rest) label i value -> do
-- --   --   types' <- traverse fAtom types
-- --   --   Variant (Ext types' rest) label i <$> fAtom value
-- --   -- VariantTy (Ext items rest) -> do
-- --   --   items' <- traverse fAtom items
-- --   --   return $ VariantTy $ Ext items' rest
-- --   ACase e alts ty -> ACase <$> fAtom e <*> mapM traverseAAlt alts <*> fAtom ty
-- --   -- DataConRef dataDef params args -> DataConRef dataDef <$>
-- --   --   traverse fAtom params <*> traverseNestedArgs args
-- --   -- BoxedRef b ptr size body -> do
-- --   --   ptr'  <- fAtom ptr
-- --   --   size' <- buildScoped $ evalBlockE def size
-- --   --   (Abs _ decls, Abs b' body') <- buildAbs b \x ->
-- --   --     extendR (b@>x) $ evalBlockE def (Block Empty $ Atom body)
-- --   --   case decls of
-- --   --     Empty -> return $ BoxedRef b' ptr' size' body'
-- --   --     _ -> error "Traversing the body atom shouldn't produce decls"
-- --   ProjectElt _ _ -> substBuilderR atom
-- --   where
-- --     traverseNestedArgs :: Nest DataConRefBinding i -> m (Nest DataConRefBinding o)
-- --     traverseNestedArgs Empty = return Empty
-- --     -- traverseNestedArgs (Nest (DataConRefBinding b ref) rest) = do
-- --     --   ref' <- fAtom ref
-- --     --   b' <- substBuilderR b
-- --     --   v <- freshVarE UnknownBinder b'
-- --     --   rest' <- extendR (b @> Var v) $ traverseNestedArgs rest
-- --     --   return $ Nest (DataConRefBinding (Bind v) ref') rest'

-- --     traverseAAlt = undefined
-- --     -- traverseAAlt (Abs bs a) = do
-- --     --   bs' <- mapM (mapM fAtom) bs
-- --     --   (Abs bs'' b) <- buildNAbs bs' \xs -> extendR (newEnv bs' xs) $ fAtom a
-- --     --   case b of
-- --     --     Block Empty (Atom r) -> return $ Abs bs'' r
-- --     --     _                    -> error "ACase alternative traversal has emitted decls or exprs!"

-- transformModuleAsBlock :: (Block i -> Block o) -> Module i -> Module o
-- transformModuleAsBlock = undefined
-- -- transformModuleAsBlock transform (Module ir decls bindings) = do
-- --   let localVars = filter (not . isGlobal . varName) $ bindingsAsVars $ freeVars bindings
-- --   let block = Block decls $ Atom $ mkConsList $ map Var localVars
-- --   let (Block newDecls (Atom newResult)) = transform block
-- --   let newLocalVals = ignoreExcept $ fromConsList newResult
-- --   Module ir newDecls $ scopelessSubst (newEnv localVars newLocalVals) bindings

-- indexSetSizeE :: MonadBuilder n m => Type n -> m (Atom n)
-- indexSetSizeE (TC con) = case con of
--   UnitType                   -> return $ IdxRepVal 1
--   IntRange low high -> clampPositive =<< high `isub` low
--   IndexRange n low high -> do
--     low' <- case low of
--       InclusiveLim x -> indexToIntE x
--       ExclusiveLim x -> indexToIntE x >>= iadd (IdxRepVal 1)
--       Unlimited      -> return $ IdxRepVal 0
--     high' <- case high of
--       InclusiveLim x -> indexToIntE x >>= iadd (IdxRepVal 1)
--       ExclusiveLim x -> indexToIntE x
--       Unlimited      -> indexSetSizeE n
--     clampPositive =<< high' `isub` low'
--   PairType a b -> bindM2 imul (indexSetSizeE a) (indexSetSizeE b)
--   ParIndexRange _ _ _ -> error "Shouldn't be querying the size of a ParIndexRange"
--   _ -> error $ "Not implemented " ++ pprint con
-- indexSetSizeE (RecordTy (NoExt types)) = do
--   sizes <- traverse indexSetSizeE types
--   foldM imul (IdxRepVal 1) sizes
-- indexSetSizeE (VariantTy (NoExt types)) = do
--   sizes <- traverse indexSetSizeE types
--   foldM iadd (IdxRepVal 0) sizes
-- indexSetSizeE ty = error $ "Not implemented " ++ pprint ty

-- clampPositive :: MonadBuilder n m => Atom n -> m (Atom n)
-- clampPositive x = do
--   isNegative <- x `ilt` (IdxRepVal 0)
--   select isNegative (IdxRepVal 0) x

-- -- XXX: Be careful if you use this function as an interpretation for
-- --      IndexAsInt instruction, as for Int and IndexRanges it will
-- --      generate the same instruction again, potentially leading to an
-- --      infinite loop.
-- indexToIntE :: MonadBuilder n m => Atom n -> m (Atom n)
-- indexToIntE (Con (IntRangeVal _ _ i))     = return i
-- indexToIntE (Con (IndexRangeVal _ _ _ i)) = return i
-- indexToIntE idx = do
--   idxTy <- getTypeE idx
--   case idxTy of
--     UnitTy  -> return $ IdxRepVal 0
--     PairTy _ rType -> do
--       (lVal, rVal) <- fromPair idx
--       lIdx  <- indexToIntE lVal
--       rIdx  <- indexToIntE rVal
--       rSize <- indexSetSizeE rType
--       imul rSize lIdx >>= iadd rIdx
--     TC (IntRange _ _)     -> indexAsInt idx
--     TC (IndexRange _ _ _) -> indexAsInt idx
--     TC (ParIndexRange _ _ _) -> error "Int casts unsupported on ParIndexRange"
--     RecordTy (NoExt types) -> do
--       sizes <- traverse indexSetSizeE types
--       (strides, _) <- scanM (\sz prev -> (prev,) <$> imul sz prev) sizes (IdxRepVal 1)
--       -- Unpack and sum the strided contributions
--       subindices <- getUnpacked idx
--       subints <- traverse indexToIntE subindices
--       scaled <- mapM (uncurry imul) $ zip (toList strides) subints
--       foldM iadd (IdxRepVal 0) scaled
--     -- VariantTy (NoExt types) -> do
--     --   sizes <- traverse indexSetSizeE types
--     --   (offsets, _) <- scanM (\sz prev -> (prev,) <$> iadd sz prev) sizes (IdxRepVal 0)
--     --   -- Build and apply a case expression
--     --   alts <- flip mapM (zip (toList offsets) (toList types)) $
--     --     \(offset, subty) -> buildNAbs (toNest [Ignore subty]) \[subix] -> do
--     --       i <- indexToIntE subix
--     --       iadd offset i
--     -- --   emit $ Case idx alts IdxRepTy
--     ty -> error $ "Unexpected type " ++ pprint ty

-- intToIndexE :: MonadBuilder n m => Type n -> Atom n -> m (Atom n)
-- intToIndexE (TC con) i = case con of
--   IntRange        low high   -> return $ Con $ IntRangeVal        low high i
--   IndexRange from low high   -> return $ Con $ IndexRangeVal from low high i
--   UnitType                   -> return $ UnitVal
--   PairType a b -> do
--     bSize <- indexSetSizeE b
--     iA <- intToIndexE a =<< idiv i bSize
--     iB <- intToIndexE b =<< irem i bSize
--     return $ PairVal iA iB
--   ParIndexRange _ _ _ -> error "Int casts unsupported on ParIndexRange"
--   _ -> error $ "Unexpected type " ++ pprint con
-- intToIndexE (RecordTy (NoExt types)) i = do
--   sizes <- traverse indexSetSizeE types
--   (strides, _) <- scanM
--     (\sz prev -> do {v <- imul sz prev; return ((prev, v), v)}) sizes (IdxRepVal 1)
--   offsets <- flip mapM (zip (toList types) (toList strides)) $
--     \(ty, (s1, s2)) -> do
--       x <- irem i s2
--       y <- idiv x s1
--       intToIndexE ty y
--   return $ Record (restructure offsets types)
-- intToIndexE (VariantTy (NoExt types)) i = do
--   sizes <- traverse indexSetSizeE types
--   (offsets, _) <- scanM (\sz prev -> (prev,) <$> iadd sz prev) sizes (IdxRepVal 0)
--   let
--     reflect = reflectLabels types
--     -- Find the right index by looping through the possible offsets
--     go prev ((label, repeatNum), ty, offset) = do
--       shifted <- isub i offset
--       -- TODO: This might run intToIndex on negative indices. Fix this!
--       index   <- intToIndexE ty shifted
--       beforeThis <- ilt i offset
--       select beforeThis prev $ Variant (NoExt types) label repeatNum index
--     ((l0, 0), ty0, _):zs = zip3 (toList reflect) (toList types) (toList offsets)
--   start <- Variant (NoExt types) l0 0 <$> intToIndexE ty0 i
--   foldM go start zs
-- intToIndexE ty _ = error $ "Unexpected type " ++ pprint ty
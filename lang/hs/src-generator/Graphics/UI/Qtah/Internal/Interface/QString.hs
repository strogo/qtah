{-# LANGUAGE CPP #-}

module Graphics.UI.Qtah.Internal.Interface.QString (
  c_QString,
  ) where

import Foreign.Cppop.Generator.Spec
import Foreign.Cppop.Generator.Std

c_QString =
  classModifyEncoding
  (\c -> c { classCppCType = Just $ TPtr TChar
           , classCppDecoder = Just $ CppCoderFn $ ident "QString"
           , classCppEncoder = Just $ CppCoderExpr [Just "strdup(", Nothing, Just ".toStdString().c_str())"]
           }) $
  classCopyEncodingFrom c_std__string $
  makeClass (ident "QString") Nothing [] [] []

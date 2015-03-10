--
-- Copyright © 2013-2014 Anchor Systems, Pty Ltd and Others
--
-- The code in this file, and the program it is a part of, is
-- made available to you by its authors as open source software:
-- you can redistribute it and/or modify it under the terms of
-- the 3-clause BSD licence.
--

{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TupleSections         #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
-- Hide warnings for the deprecated ErrorT transformer:
{-# OPTIONS_GHC -fno-warn-warnings-deprecations #-}

module Marquise.IO.Writer
(
) where

import qualified Control.Exception as E

import Marquise.Classes
import Marquise.IO.Connection
import Marquise.Types
import Vaultaire.Types

instance MarquiseWriterMonad IO where
  transmitBytes broker origin bytes =
    withConnection ("tcp://" ++ broker ++ ":5560") $ \c -> do
      send (PassThrough bytes) origin c
      ack <- recv c
      case ack of
        OnDisk             -> return ()
        InvalidWriteOrigin -> E.throw $ MarquiseException "invalid origin" 

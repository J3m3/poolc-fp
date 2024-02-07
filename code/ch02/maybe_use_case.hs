{- HLINT ignore -}

type Request = String

type Response = String

type Data = String

{-
  response1 = httpGet request1
  data1 = extractData response1 -- Couldn't match type `Maybe Response` with `Response`
  request2 = generateRequest data1

  response2 = httpGet request2
  data2 = extractData response2 -- Couldn't match type `Maybe Response` with `Response`
  request3 = generateRequest data2
  ...
-}
extractData :: Response -> Data
extractData = undefined

generateRequest :: Data -> Request
generateRequest = undefined

httpGet :: Request -> Maybe Response
httpGet = undefined

getFinalResult :: Request -> Maybe Response
-- getFinalResult request =
--   let response1 = httpGet request
--       data1 = extractData response1
--       request1 = generateRequest data1

--       response2 = httpGet request
--       data2 = extractData response2
--       request2 = generateRequest data2
--    in request2
getFinalResult request1 =
  httpGet request1
    >>= ( \response1 ->
            let data1 = extractData response1
                request2 = generateRequest data1
             in httpGet request2
        )
    >>= ( \response2 ->
            let data2 = extractData response2
                request3 = generateRequest data2
             in httpGet request3
        )

getFinalResult' :: Request -> Maybe Response
getFinalResult' request =
  httpGet request
    >>= httpGet . generateRequest . extractData
    >>= httpGet . generateRequest . extractData

getFinalResult'' :: Request -> Maybe Response
getFinalResult'' request = do
  response1 <- httpGet request
  let data1 = extractData response1
  let request2 = generateRequest data1

  response2 <- httpGet request2
  let data2 = extractData response2
  let request3 = generateRequest data2

  httpGet request3

-- :type (f 0 >>= g)
f :: Int -> Maybe String
f = undefined

g :: String -> Maybe Bool
g = undefined




### Events - what's wrong?

 - Events need intermediate state

 - Events are time dependent

 ###

pluggedIn = false
fryingBacon = false

cord.on 'plugin', ->
  pluggedIn = true

pan.on 'meatPlaced', ->
  if pluggedIn then fryingBacon = true
























###

- Internal state is prone to accidents

###

pluggedIn = true
meatPlaced = true
fryingBacon = false

cord.on 'plugin', ->
  pluggedIn = true
  checkFrying()

pan.on 'meatPlaced', ->
  meatPlaced = true
  checkFrying()

checkFrying = ->
  fryingBacon = pluggedIn && meatPlaced




























###

- state grows exponentially with each new element of internal representation

###

pluggedIn = false
meatPlaced = false
meatType = 'pig' # [cow, chicken, pig]

fryingBacon = false
fryingHamburger = false
fryingChicken = false


cord.on 'plugin', ->
  pluggedIn = true
  checkFrying()

pan.on 'meatPlaced', ->
  meatPlaced = true
  checkFrying()

checkFrying = ->
  switch meatType
    case 'pig':
      fryingBacon = pluggedIn && meatPlaced
    case 'cow':
      fryingHamburger = pluggedIn && meatPlaced
    case 'chicken'
      fryingChicken = pluggedIn && meatPlaced

























###

FRP is about "datatypes that represent a value 'over time'"

###

cordStream = cord.asEventStream 'plugin'
meatStream = pan.asEventStream 'meatPlaced'
fryingMeat = cordStream.and meatStream





























###

- FRP removes intermediary inconsistencies

###


cordStream = cord.asEventStream 'plugin'
meatStream = pan.asEventStream 'meatPlaced'
fryingMeat = cordStream.and meatStream

 # a stream of constant values
meatType = Bacon.constant 'pig'

fryingBacon = fryingMeat.and meatType.map (type) -> type is 'pig'
fryingCow = fryingMeat.and meatType.map (type) -> type is 'cow'
fryingChicken = fryingMeat.and meatType.map (type) -> type is 'chicken'















###

- FRP streams are composable
- FRP is declaritive

###

equal = (stream, val) -> 
  stream.map (item) -> item is val

cordStream = cord.asEventStream 'plugin'
meatStream = pan.asEventStream 'meatPlaced'
fryingMeat = cordStream.and meatStream
meatType = Bacon.constant 'pig'

fryingBacon = fryingMeat.and equal meatType, 'pig'
fryingCow = fryingMeat.and equal meatType, 'cow'
fryingChicken = fryingMeat.and equal meatType, 'chicken'




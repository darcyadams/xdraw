Animation = require 'ainojs-animation'
easing = require 'ainojs-easing'
_ = require 'lodash'

###
  Purpose: Easily add Enter and Leave animations to a React Component (that is a child of React's TransitionGroup)
  
  The react component must have these properties for an Enter Animation

  initialState: object - Only required when there are additional states to those being animated
                         The initial state of the component, which will have animated properties mixed in
                         Note: getInitialState on your component is overwritten by this mixin

  ENTER ANIMATION PROPS
  enterDuration: number (millisecoinds), defaults to 300
  enterStateStart: object, required, no default
  enterStateEnd: object, required, no default
  enterEasing: string, defaults to 'linear' (ainojs-easing function name: https://github.com/aino/ainojs-easing)
  
  LEAVE ANIMATION PROPS
  leaveDuration: number (millisecoinds), defaults to 300
  leaveStateStart: object, required, no default
  leaveStateEnd: object, required, no default
  leaveEasing: string, defaults to 'linear' (ainojs-easing function name: https://github.com/aino/ainojs-easing)
  
  finaally, the @state properties must be applied as inline styles in the component's render method
###

module.exports =
  
  getInitialState: -> _.extend(@initialState or {}, @enterStateStart or {})
    

  componentWillEnter: (done) ->
    unless @enterStateStart? and @enterStateEnd?
      console?.warn "No 'enter' animation will be performed as @enterStateStart & @enterStateEnd are required. Check #{@displayName} Component."
      return

    animation = new Animation {
        duration: @enterDuration or 300
        easing: easing(@enterEasing or 'linear')
    }

    # Note: need to clone here so animate class does not alter initial values
    stateStart = _.clone(@enterStateStart)
    
    # Note: Not feeding init @state directly, because that will clobber @state properties not being animated
    animation.init stateStart
    animation.on('frame', @onFrame)
    animation.on('complete', done)

    animation.animateTo @enterStateEnd


  componentWillLeave: (done) ->
    unless @leaveStateStart? and @leaveStateEnd?
      console?.warn "No 'leave' animation will be performed as @leaveStateStart & @leaveStateEnd are required. Check #{@displayName} Component."
      return

    animation = new Animation {
        duration: @leaveDuration or 300
        easing: easing(@leaveEasing or 'linear')
    }

    # Note: need to clone here so animate class does not alter initial values
    stateStart = _.clone(@leaveStateStart)

    # Note: Not feeding init method @state directly because that will clobber @state properties not being animated
    animation.init stateStart
    animation.on('frame', @onFrame)
    animation.on('complete', done)

    animation.animateTo @leaveStateEnd

  
  onFrame: (e) -> @setState e.values
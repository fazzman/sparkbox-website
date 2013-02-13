# When you change APP, be sure to update it in mylibs/util.js
window.APP =

  init: ->
    @setBindings()
    @hero.init()

  setBindings: ->
    $chainIcon = $(".chain-icon")

    $( "#build-reveal" ).click ->
      $( "#build-header" ).toggleClass "bh-collapsed"

    $chainIcon.click (e) ->
      APP.hero.toggle()

    $chainIcon.bind "mouseenter", ->
      $( this ).addClass( "broken" )
    $chainIcon.bind "mouseleave", ->
      $( this ).removeClass( "broken" )

  hero:

    OPEN_CLASS: "more-revealed"

    init: ->
      @$slider = $( ".hero" )
      @$wrapper = $( ".hero-wrapper" )
      @$heroMore = $( ".hero-more" )
      @$heroTeaser = $( ".hero-teaser" )
      @$iconWrapper = $( ".icon-wrapper" )
      @$chainIcon = $(".chain-icon")

    toggle: ->
      borderSize = parseInt( @$wrapper.css( "border-width" ) ) # border size, in pixels (for accurate height transitions)

      action = if @$slider.hasClass( @OPEN_CLASS ) then "closing" else "opening"

      if action is "opening"
        $( @$chainIcon ).addClass( "broken" )
        teaserHeight = @$heroTeaser.outerHeight()
        moreHeight = @$heroMore.outerHeight()
        iconHeight = @$iconWrapper.outerHeight()

        oldHeight = iconHeight + teaserHeight
        newHeight = iconHeight + moreHeight + borderSize*2
        offset = moreHeight
      else # it's closing
        teaserHeight = @$heroTeaser.outerHeight()
        moreHeight = @$heroMore.outerHeight()
        iconHeight = @$iconWrapper.outerHeight()

        oldHeight = moreHeight
        newHeight = iconHeight + teaserHeight + borderSize*2
        offset = moreHeight - iconHeight

      @$wrapper.height( oldHeight )
      @$wrapper.height() # force redraw
      if action is "opening"
        @$wrapper.animate { height: newHeight, useTranslate3d: true }, 300, -> APP.hero.openEnd() # crop!
        @$slider.animate { top: offset, useTranslate3d: true }, 300, -> APP.hero.openEnd() # slide!
      else # it's closing
        @$chainIcon.removeClass( "broken" )
        @$slider.removeClass( @OPEN_CLASS )
        # we need to recreate styles from @OPEN_CLASS
        # so we can transition from them
        @$heroMore.css
          position: "relative"
        @$iconWrapper.css
          position: "absolute"
          top: moreHeight - iconHeight
        @$heroTeaser.css
          position: "absolute"
          top: moreHeight
        @$slider.css
          top: 0
          position: "absolute"

        @$wrapper.animate { height: newHeight, useTranslate3d: true }, 300, -> APP.hero.closeEnd() # crop!
        @$slider.animate { top: -offset, useTranslate3d: true }, 300, -> APP.hero.closeEnd() # slide!

    openEnd: ->
      # clear inline styles
      @$wrapper.removeAttr( "style" )
      @$slider.removeAttr( "style" )
      # add "real" styles
      @$slider.addClass( @OPEN_CLASS )

    closeEnd: ->
      # clear inline styles
      @$wrapper.removeAttr( "style" )
      @$slider.removeAttr( "style" )
      @$heroMore.removeAttr( "style" )
      @$iconWrapper.removeAttr( "style" )
      @$heroTeaser.removeAttr( "style" )

$(document).ready ->
  APP.init()

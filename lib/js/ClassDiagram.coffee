##
Diagram = require "./Diagram"

class ClassDiagram extends Diagram

ClassDiagram::member = (kind, clz, normval)->
  holder = clz.find(".#{kind}s")
  $(normval["#{kind}s"]).each (i, e)->
    id = "#{normval.id}-#{kind}-#{e}"
    throw new Error("Already exists #{e}") if holder.find(".#{e}").length > 0
    holder.append $("<li>").addClass(e).attr("id", id).html e

ClassDiagram::declare = (normval) ->
  clz = $.jumly ".class", normval
  if normval.stereotype
    clz.find(".stereotype").html normval.stereotype
  else
    clz.find(".stereotype").hide()
    
  @member(kind, clz, normval) for kind in ["attr", "method"]

  ref = @_regByRef_ normval.id, clz
  eval "#{ref} = clz"
  @append clz

ClassDiagram::preferredWidth = ->
  @find(".class .icon").mostLeftRight().width() + 16 ##WORKAROUND: 16 is magic number.

ClassDiagram::preferredHeight = ->
  @find(".class .icon").mostTopBottom().height()

ClassDiagram::compose = ->
  @trigger "beforeCompose", [this]
  ## Resize for looks
  @find(".class .icon").each (i, e) ->
    e = $ e
    return null if e.width() > e.height()
    e.width e.height() * (1 + Math.sqrt 2)/2
  @trigger "afterCompose", [this]
  @width @preferredWidth()
  @height @preferredHeight()
  this

###
<div class="class icon">
  <span class="stereotype">abstract</span>
  <span class="name">UMLObject</span>
  <ul class="attrs">
    <li>name</li>
    <li>stereotypes</li>
  </ul>
  <ul class="methods">
    <li>activate</li>
    <li>isLeftAt(a)</li>
    <li>isRightAt(a)</li>
    <li>iconify(fixture, styles)</li>
    <li>lost</li>
  </ul>
</div>
###
HTMLElement = require "HTMLElement"
class Class extends HTMLElement
Class::_build_ = (div)->
  icon = $("<div>")
           .addClass("icon")
           .append($("<div>").addClass "stereotype")
           .append($("<div>").addClass "name")
           .append($("<ul>").addClass "attrs")
           .append($("<ul>").addClass "methods")
  div.addClass("object")
     .append(icon)

def = ->
def ".class-diagram", ClassDiagram
def ".class", Class


if typeof module != 'undefined' and module.exports
  module.exports = ClassDiagram
else
  core.ClassDiagram = ClassDiagram
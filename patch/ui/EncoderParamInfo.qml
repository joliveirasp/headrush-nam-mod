import QtQuick 2.2
import StateMap 1.0
import "../Controls/Displays"
MouseArea
{id: frame
height: col.height
width: 147
property int index: 0
property bool fullColor: false
function g(s){return Evil.getP("/Engine/"+s)}
function p(s){return g("RedirCtrl/"+s+(index+1))}
property QObjProperty colProp: p("ParamColour")
property int colIdx: colProp && colProp.translator ? colProp.translator.index : -1
property color frameColor: Evil.getScreenColourFromIndex(colIdx)
property QObjProperty lockedProp: p("ParamPedalLocked")
property bool showPedalLock: !fullColor && lockedProp.translator.state
property QObjProperty assignedProp: p("ParamPedalAssigned")
property real o: showPedalLock ? 0.5 : 1.0
property bool showPedalNoLock: !fullColor && assignedProp.translator.state
property var tp:g("Patch/Chain/ModuleType"+g("RedirCtrl/CurModule").translator.index)
property string mt:tp&&tp.translator?tp.translator.string:""
function rn(n){var a=mt.indexOf("NAM")==0,r=mt.indexOf("Reverb")==0,i=["DRIVE","LEVEL","TONE","GAIN","LOW","HIGH"].indexOf(n.toUpperCase());return i<0||!(a||r)?n:(a?["MODEL","INPUT","OUTPUT","CALIB","OFF","ON"]:["DECAY","MIX","DAMPING",n,n,n])[i]}
function tx(q,k){return rn(q&&q.translator?q.translator[k]:"")}
Loader{source:mt.indexOf("NAM")==0?"file:///usr/Evil/Resources/nam_fix.qml":"";onLoaded:item.t=frame}
Rectangle { opacity: !fullColor || colIdx < 1 ? 0.5 : 1.0; anchors.fill: parent; color: colIdx <= 0 ? "black" : frameColor; radius: 3 }
Column { id: col; anchors.centerIn: parent; spacing: highString.visible && (showPedalLock || showPedalNoLock) ? 4 : 10;
Image { visible: showPedalLock; width: 130; height: 24; verticalAlignment: Text.AlignVCenter; source: "../img/PedalLock.png" }
Image { visible: !showPedalLock && showPedalNoLock; width: 130; height: 20; verticalAlignment: Text.AlignVCenter; source: "../img/PedalNoLock.png" }
EncoderString { id: highString; opacity: o; height: 30; width: 130; what: 0; textSize: 25; prop: p("ParamNameHi"); text: tx(prop,"string") }
EncoderString { opacity: o; height: 30; width: 130; what: 0; textSize: 35; prop: p("ParamNameLo"); text: tx(prop,"string") }
EncoderString { opacity: o; height: 60; width: 130; what: 1; textSize: 85; prop: p("ParamRedirected"); text: tx(prop,"stringNoUnits") }
EncoderString { opacity: o; height: 39; width: 130; what: 2; textSize: 55; prop: p("ParamRedirected"); allowLowercase: true; text: tx(prop,"stringUnits") }
}
}

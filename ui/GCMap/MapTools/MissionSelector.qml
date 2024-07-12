import QtQuick                              2.11
import QtQuick.Controls                     2.4

import GroundControl                       1.0
ComboBox {
    id:_root
    currentIndex:           0
    model:                  missionModel
    property var missionModel: []
    property var planList: []

    onPlanListChanged: {
        missionModel=null
        for(var i=0;i<planList;++i){
            missionModel.push(lanList[i].name)
        }
    }

    onActivated: {
        console.log(currentText+currentIndex)
    }
}

# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'qualitycheck.ui'
#
# Created by: PyQt5 UI code generator 5.10.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_qualitycheck(object):
    def setupUi(self, qualitycheck):
        qualitycheck.setObjectName("qualitycheck")
        qualitycheck.resize(525, 300)
        self.horizontalLayout = QtWidgets.QHBoxLayout(qualitycheck)
        self.horizontalLayout.setContentsMargins(11, 11, 11, 11)
        self.horizontalLayout.setSpacing(6)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.frame = QtWidgets.QFrame(qualitycheck)
        self.frame.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.frame.setFrameShadow(QtWidgets.QFrame.Raised)
        self.frame.setObjectName("frame")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.frame)
        self.verticalLayout.setContentsMargins(11, 11, 11, 11)
        self.verticalLayout.setSpacing(50)
        self.verticalLayout.setObjectName("verticalLayout")
        self.label_4 = QtWidgets.QLabel(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.label_4.setFont(font)
        self.label_4.setAlignment(QtCore.Qt.AlignCenter)
        self.label_4.setObjectName("label_4")
        self.verticalLayout.addWidget(self.label_4)
        self.qualityGeneratorCheck = QtWidgets.QCheckBox(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.qualityGeneratorCheck.setFont(font)
        self.qualityGeneratorCheck.setObjectName("qualityGeneratorCheck")
        self.verticalLayout.addWidget(self.qualityGeneratorCheck)
        self.qualityReceiverCheck = QtWidgets.QCheckBox(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.qualityReceiverCheck.setFont(font)
        self.qualityReceiverCheck.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.qualityReceiverCheck.setObjectName("qualityReceiverCheck")
        self.verticalLayout.addWidget(self.qualityReceiverCheck)
        self.qualityCheckButtons = QtWidgets.QDialogButtonBox(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.qualityCheckButtons.setFont(font)
        self.qualityCheckButtons.setOrientation(QtCore.Qt.Horizontal)
        self.qualityCheckButtons.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.qualityCheckButtons.setCenterButtons(True)
        self.qualityCheckButtons.setObjectName("qualityCheckButtons")
        self.verticalLayout.addWidget(self.qualityCheckButtons)
        self.horizontalLayout.addWidget(self.frame)

        self.retranslateUi(qualitycheck)
        QtCore.QMetaObject.connectSlotsByName(qualitycheck)

    def retranslateUi(self, qualitycheck):
        _translate = QtCore.QCoreApplication.translate
        qualitycheck.setWindowTitle(_translate("qualitycheck", "qualitycheck"))
        self.label_4.setText(_translate("qualitycheck", "Before continuing to Step 3, please provide the following information:"))
        self.qualityGeneratorCheck.setText(_translate("qualitycheck", "I\'ve verified the quality of the signal generator output"))
        self.qualityReceiverCheck.setText(_translate("qualitycheck", "I\'ve verified the quality of the transmit observation receiver"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    qualitycheck = QtWidgets.QDialog()
    ui = Ui_qualitycheck()
    ui.setupUi(qualitycheck)
    qualitycheck.show()
    sys.exit(app.exec_())


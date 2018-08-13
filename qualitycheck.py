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
        self.gridLayout = QtWidgets.QGridLayout(self.frame)
        self.gridLayout.setContentsMargins(11, 11, 11, 11)
        self.gridLayout.setHorizontalSpacing(6)
        self.gridLayout.setVerticalSpacing(34)
        self.gridLayout.setObjectName("gridLayout")
        self.label_4 = QtWidgets.QLabel(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.label_4.setFont(font)
        self.label_4.setAlignment(QtCore.Qt.AlignCenter)
        self.label_4.setObjectName("label_4")
        self.gridLayout.addWidget(self.label_4, 0, 0, 1, 2)
        self.qualityReceiverCheck = QtWidgets.QCheckBox(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.qualityReceiverCheck.setFont(font)
        self.qualityReceiverCheck.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.qualityReceiverCheck.setObjectName("qualityReceiverCheck")
        self.gridLayout.addWidget(self.qualityReceiverCheck, 3, 0, 1, 2)
        self.qualityGeneratorCheck = QtWidgets.QCheckBox(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.qualityGeneratorCheck.setFont(font)
        self.qualityGeneratorCheck.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.qualityGeneratorCheck.setObjectName("qualityGeneratorCheck")
        self.gridLayout.addWidget(self.qualityGeneratorCheck, 2, 0, 1, 2)
        self.qualityCheckButtons = QtWidgets.QDialogButtonBox(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.qualityCheckButtons.setFont(font)
        self.qualityCheckButtons.setOrientation(QtCore.Qt.Horizontal)
        self.qualityCheckButtons.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.qualityCheckButtons.setCenterButtons(True)
        self.qualityCheckButtons.setObjectName("qualityCheckButtons")
        self.gridLayout.addWidget(self.qualityCheckButtons, 4, 0, 1, 2)
        self.label = QtWidgets.QLabel(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.label.setFont(font)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 1, 0, 1, 1)
        self.dutNmse = QtWidgets.QLineEdit(self.frame)
        self.dutNmse.setObjectName("dutNmse")
        self.gridLayout.addWidget(self.dutNmse, 1, 1, 1, 1)
        self.gridLayout.setRowStretch(0, 1)
        self.gridLayout.setRowStretch(1, 1)
        self.gridLayout.setRowStretch(2, 1)
        self.gridLayout.setRowStretch(3, 1)
        self.gridLayout.setRowStretch(4, 1)
        self.horizontalLayout.addWidget(self.frame)

        self.retranslateUi(qualitycheck)
        QtCore.QMetaObject.connectSlotsByName(qualitycheck)

    def retranslateUi(self, qualitycheck):
        _translate = QtCore.QCoreApplication.translate
        qualitycheck.setWindowTitle(_translate("qualitycheck", "qualitycheck"))
        self.label_4.setText(_translate("qualitycheck", "Before continuing to Step 3, please provide the following information:"))
        self.qualityReceiverCheck.setText(_translate("qualitycheck", "I\'ve verified the quality of the transmit observation receiver"))
        self.qualityGeneratorCheck.setText(_translate("qualitycheck", "I\'ve verified the quality of the signal generator output"))
        self.label.setText(_translate("qualitycheck", "DUT Output NMSE:"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    qualitycheck = QtWidgets.QDialog()
    ui = Ui_qualitycheck()
    ui.setupUi(qualitycheck)
    qualitycheck.show()
    sys.exit(app.exec_())


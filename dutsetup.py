# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'dutsetup.ui'
#
# Created by: PyQt5 UI code generator 5.10.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_DUTSetup(object):
    def setupUi(self, DUTSetup):
        DUTSetup.setObjectName("DUTSetup")
        DUTSetup.resize(590, 302)
        self.dutStackedWidget = QtWidgets.QStackedWidget(DUTSetup)
        self.dutStackedWidget.setGeometry(QtCore.QRect(0, 0, 591, 301))
        self.dutStackedWidget.setObjectName("dutStackedWidget")
        self.page = QtWidgets.QWidget()
        self.page.setObjectName("page")
        self.verticalLayoutWidget = QtWidgets.QWidget(self.page)
        self.verticalLayoutWidget.setGeometry(QtCore.QRect(10, 20, 571, 261))
        self.verticalLayoutWidget.setObjectName("verticalLayoutWidget")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.verticalLayoutWidget)
        self.verticalLayout.setContentsMargins(15, 0, 15, 6)
        self.verticalLayout.setSpacing(30)
        self.verticalLayout.setObjectName("verticalLayout")
        self.label = QtWidgets.QLabel(self.verticalLayoutWidget)
        self.label.setMaximumSize(QtCore.QSize(16777215, 16777215))
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.label.setFont(font)
        self.label.setLayoutDirection(QtCore.Qt.RightToLeft)
        self.label.setTextFormat(QtCore.Qt.AutoText)
        self.label.setScaledContents(False)
        self.label.setAlignment(QtCore.Qt.AlignCenter)
        self.label.setWordWrap(False)
        self.label.setIndent(100)
        self.label.setObjectName("label")
        self.verticalLayout.addWidget(self.label)
        self.groupBox = QtWidgets.QGroupBox(self.verticalLayoutWidget)
        self.groupBox.setStyleSheet("QGroupBox {border:none}")
        self.groupBox.setTitle("")
        self.groupBox.setObjectName("groupBox")
        self.label_2 = QtWidgets.QLabel(self.groupBox)
        self.label_2.setGeometry(QtCore.QRect(10, 5, 61, 16))
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        font.setBold(True)
        font.setWeight(75)
        self.label_2.setFont(font)
        self.label_2.setObjectName("label_2")
        self.pushButton = QtWidgets.QPushButton(self.groupBox)
        self.pushButton.setGeometry(QtCore.QRect(70, 0, 241, 25))
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.pushButton.setFont(font)
        self.pushButton.setStyleSheet("QPushButton {border:1px solid rgb(5, 70, 127);border-radius:5px;background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.489, stop:0 rgba(140, 202, 235, 255), stop:1 rgba(216, 242, 255, 255))}")
        self.pushButton.setCheckable(True)
        self.pushButton.setChecked(True)
        self.pushButton.setObjectName("pushButton")
        self.pushButton_2 = QtWidgets.QPushButton(self.groupBox)
        self.pushButton_2.setEnabled(False)
        self.pushButton_2.setGeometry(QtCore.QRect(320, 0, 191, 25))
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.pushButton_2.setFont(font)
        self.pushButton_2.setCheckable(False)
        self.pushButton_2.setChecked(False)
        self.pushButton_2.setObjectName("pushButton_2")
        self.verticalLayout.addWidget(self.groupBox)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setContentsMargins(15, -1, 0, -1)
        self.horizontalLayout.setSpacing(0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.label_3 = QtWidgets.QLabel(self.verticalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        font.setBold(True)
        font.setWeight(75)
        self.label_3.setFont(font)
        self.label_3.setObjectName("label_3")
        self.horizontalLayout.addWidget(self.label_3)
        self.sisoRadio = QtWidgets.QRadioButton(self.verticalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.sisoRadio.setFont(font)
        self.sisoRadio.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.sisoRadio.setObjectName("sisoRadio")
        self.dutButtonGroup = QtWidgets.QButtonGroup(DUTSetup)
        self.dutButtonGroup.setObjectName("dutButtonGroup")
        self.dutButtonGroup.addButton(self.sisoRadio)
        self.horizontalLayout.addWidget(self.sisoRadio)
        self.mimoRadio = QtWidgets.QRadioButton(self.verticalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.mimoRadio.setFont(font)
        self.mimoRadio.setObjectName("mimoRadio")
        self.dutButtonGroup.addButton(self.mimoRadio)
        self.horizontalLayout.addWidget(self.mimoRadio)
        self.misoRadio = QtWidgets.QRadioButton(self.verticalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.misoRadio.setFont(font)
        self.misoRadio.setObjectName("misoRadio")
        self.dutButtonGroup.addButton(self.misoRadio)
        self.horizontalLayout.addWidget(self.misoRadio)
        self.simoRadio = QtWidgets.QRadioButton(self.verticalLayoutWidget)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.simoRadio.setFont(font)
        self.simoRadio.setObjectName("simoRadio")
        self.dutButtonGroup.addButton(self.simoRadio)
        self.horizontalLayout.addWidget(self.simoRadio)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.dutReadyButton = QtWidgets.QPushButton(self.verticalLayoutWidget)
        self.dutReadyButton.setMinimumSize(QtCore.QSize(0, 32))
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.dutReadyButton.setFont(font)
        self.dutReadyButton.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.dutReadyButton.setStyleSheet("QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 85, 0, 255), stop:1 rgba(0, 158, 0, 255));color:white;border-radius: 5px; border: 3px solid green;}\n"
"\n"
"QPushButton:hover{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 134, 0, 255), stop:1 rgba(0, 184, 0, 255));}\n"
"")
        self.dutReadyButton.setObjectName("dutReadyButton")
        self.verticalLayout.addWidget(self.dutReadyButton)
        self.dutStackedWidget.addWidget(self.page)
        self.page_2 = QtWidgets.QWidget()
        self.page_2.setObjectName("page_2")
        self.frame = QtWidgets.QFrame(self.page_2)
        self.frame.setGeometry(QtCore.QRect(20, 20, 551, 261))
        self.frame.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.frame.setFrameShadow(QtWidgets.QFrame.Raised)
        self.frame.setObjectName("frame")
        self.gridLayout = QtWidgets.QGridLayout(self.frame)
        self.gridLayout.setVerticalSpacing(23)
        self.gridLayout.setObjectName("gridLayout")
        spacerItem = QtWidgets.QSpacerItem(20, 17, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        self.gridLayout.addItem(spacerItem, 6, 0, 1, 1)
        self.rfInputEdit = QtWidgets.QLineEdit(self.frame)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.rfInputEdit.setFont(font)
        self.rfInputEdit.setObjectName("rfInputEdit")
        self.gridLayout.addWidget(self.rfInputEdit, 4, 1, 1, 1)
        self.rfInputLabel = QtWidgets.QLabel(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.rfInputLabel.setFont(font)
        self.rfInputLabel.setObjectName("rfInputLabel")
        self.gridLayout.addWidget(self.rfInputLabel, 4, 0, 1, 1)
        self.dutReadyButton_2 = QtWidgets.QPushButton(self.frame)
        self.dutReadyButton_2.setMinimumSize(QtCore.QSize(0, 32))
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.dutReadyButton_2.setFont(font)
        self.dutReadyButton_2.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.dutReadyButton_2.setStyleSheet("QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 85, 0, 255), stop:1 rgba(0, 158, 0, 255));color:white;border-radius: 5px; border: 3px solid green;}\n"
"\n"
"QPushButton:hover{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 134, 0, 255), stop:1 rgba(0, 184, 0, 255));}\n"
"")
        self.dutReadyButton_2.setObjectName("dutReadyButton_2")
        self.gridLayout.addWidget(self.dutReadyButton_2, 7, 0, 1, 2)
        self.rfOutputLabel = QtWidgets.QLabel(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(10)
        self.rfOutputLabel.setFont(font)
        self.rfOutputLabel.setObjectName("rfOutputLabel")
        self.gridLayout.addWidget(self.rfOutputLabel, 5, 0, 1, 1)
        self.label_4 = QtWidgets.QLabel(self.frame)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        self.label_4.setFont(font)
        self.label_4.setAlignment(QtCore.Qt.AlignCenter)
        self.label_4.setObjectName("label_4")
        self.gridLayout.addWidget(self.label_4, 0, 0, 1, 2)
        self.rfOutputEdit = QtWidgets.QLineEdit(self.frame)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.rfOutputEdit.setFont(font)
        self.rfOutputEdit.setObjectName("rfOutputEdit")
        self.gridLayout.addWidget(self.rfOutputEdit, 5, 1, 1, 1)
        self.backButton = QtWidgets.QPushButton(self.page_2)
        self.backButton.setGeometry(QtCore.QRect(10, 10, 61, 23))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.backButton.sizePolicy().hasHeightForWidth())
        self.backButton.setSizePolicy(sizePolicy)
        self.backButton.setMinimumSize(QtCore.QSize(10, 0))
        font = QtGui.QFont()
        font.setPointSize(10)
        font.setUnderline(True)
        self.backButton.setFont(font)
        self.backButton.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.backButton.setStyleSheet("QPushButton:Hover{color:rgb(0, 0, 255)}")
        self.backButton.setFlat(True)
        self.backButton.setObjectName("backButton")
        self.dutStackedWidget.addWidget(self.page_2)

        self.retranslateUi(DUTSetup)
        self.dutStackedWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(DUTSetup)

    def retranslateUi(self, DUTSetup):
        _translate = QtCore.QCoreApplication.translate
        DUTSetup.setWindowTitle(_translate("DUTSetup", "Form"))
        self.label.setText(_translate("DUTSetup", "Welcome! To get started please select the appropriate mode and DUT setup:"))
        self.label_2.setText(_translate("DUTSetup", "Mode:"))
        self.pushButton.setText(_translate("DUTSetup", "Generate, Analyze, && Process Signals"))
        self.pushButton_2.setText(_translate("DUTSetup", "Generate && Analyze Signals"))
        self.label_3.setText(_translate("DUTSetup", "Setup:"))
        self.sisoRadio.setText(_translate("DUTSetup", "SISO"))
        self.mimoRadio.setText(_translate("DUTSetup", "MIMO"))
        self.misoRadio.setText(_translate("DUTSetup", "MISO"))
        self.simoRadio.setText(_translate("DUTSetup", "SIMO"))
        self.dutReadyButton.setText(_translate("DUTSetup", "Submit"))
        self.rfInputLabel.setText(_translate("DUTSetup", "Number of DUT RF Inputs:"))
        self.dutReadyButton_2.setText(_translate("DUTSetup", "Submit"))
        self.rfOutputLabel.setText(_translate("DUTSetup", "Number of DUT RF Outputs:"))
        self.label_4.setText(_translate("DUTSetup", "Provide the appropriate quantities for the equipment:"))
        self.backButton.setText(_translate("DUTSetup", "Go Back"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    DUTSetup = QtWidgets.QWidget()
    ui = Ui_DUTSetup()
    ui.setupUi(DUTSetup)
    DUTSetup.show()
    sys.exit(app.exec_())


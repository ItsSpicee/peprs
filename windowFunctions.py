# windowFunctions.py contains all the functions that are needed to control the window size, display, and menu functionality

from PyQt5.QtWidgets import (QPushButton, QStackedWidget, QMessageBox, QFileDialog, qApp,QDialog, QLineEdit, QComboBox, QRadioButton, QCheckBox)
from PyQt5.QtCore import (QSettings,QSize,QPoint)
from PyQt5.QtGui import (QGuiApplication)

import inspect

redBorder = "QGroupBox{background-color:rgb(247, 247, 247); border:2px solid #f24646}"

def tabCounterIncrement(self,dir):
	i = self.ui.stepTabs.currentIndex()
	if i == 1:
		if dir == "up":
			tabCounterIncrement.counterTwo = 1;
		elif dir == "down":
			tabCounterIncrement.counterTwo = 0;
	elif i == 0:
		if dir == "up":
			tabCounterIncrement.counterThree = 1;
		elif dir == "down":
			tabCounterIncrement.counterThree = 0;
tabCounterIncrement.counterTwo = 0
tabCounterIncrement.counterThree = 0
	 
def openDialog(self):
	# load settings
	# settings = QSettings("EmRG", "my_app")
	# guirestore(self.ui,settings)
	
	file = str(QFileDialog.getOpenFileName(self, "Select a File", "./Saved Parameter Setups"))
	fileList = file.split(",")
	file = fileList[0]
	file = file.replace("'","")
	file = file.replace("(","")
	guirestore(self.ui, QSettings(file, QSettings.IniFormat))

def saveDialog(self):
	# save settings
	#settings = QSettings("EmRG", "my_app") 
	# guisave(self.ui,settings)
	
	fileInfo = str(QFileDialog.getSaveFileName(self,'Save File Location',"./Saved Parameter Setups","QSettings Files (*.ini)"))	
	fileList = fileInfo.split(",")
	file = fileList[0]
	file = file.replace("'","")
	file = file.replace("(","")
	guisave(self.ui, QSettings(file, QSettings.IniFormat))
		
def closeButton(self):
	reply=QMessageBox.question(self,'Exit Confirmation',"Are you sure you want to close the program?",QMessageBox.Yes|QMessageBox.No)
	if reply == QMessageBox.Yes:
		qApp.quit()

def changeStepTab(self,safety):
	# determine size window should be set to 
	maxTrue = self.isMaximized()
	screen = QGuiApplication.primaryScreen()
	screenSize = screen.availableSize()
	height = screenSize.height()
	maxHeight = height - 50
	
	i = self.ui.stepTabs.currentIndex()
	measStack = self.ui.measStack.currentIndex()
	measTabVsa = self.ui.vsaMeasParamTabs.currentIndex()
	measTabVsg = self.ui.vsgMeasParamTabs.currentIndex()
	downEnabled = self.ui.vsaWorkflow_vsaMeas.currentIndex()
	upEnabled = self.ui.vsgWorkflow_vsgMeas.currentIndex()
	vsgStack = self.ui.awgParamsStack_vsgMeas.currentIndex()
	safetyState = self.ui.actionEnable_Safety_Check.isChecked()
	# has calibration been done parameters
	vsgCal = self.ui.vsgCalType.currentIndex()
	vsaCal = self.ui.generateVSACalCheck.isChecked()
	
	if maxTrue == False:
		if i == 2:
			self.setMinimumSize(1265,700)
			self.resize(1265, 700)
			self.center()
		elif i == 1:
			counterTwo = tabCounterIncrement.counterTwo
			if counterTwo == 0 and safetyState:
				safety.exec_()
				tabCounterIncrement(self,"up")
			else:
				self.setMinimumSize(1265,maxHeight)
				self.resize(1265,maxHeight)
				self.center()
		elif i == 0:
			self.setMinimumSize(1265,maxHeight)
			self.resize(1265,maxHeight)
			self.center()
			# if no calibration has been done, disable calibration validation tab
			if (vsgCal == 0 or vsgCal == 4) and vsaCal == False:
				self.ui.algoTabs.setTabEnabled(0,False)
			else:
				self.ui.algoTabs.setTabEnabled(0,True)
		elif i == 3:
			self.setMinimumSize(1265,700)
			self.resize(1265,700)
			self.center()
			
def switchMeasTabVSA(self):
	currentTab = self.ui.vsaMeasParamTabs.currentIndex()
	vsaChecked = self.ui.vsaMeasSet.isChecked()
	vsaChecked_2 = self.ui.vsaMeasSet_2.isChecked()
	vsaDownChecked = self.ui.downSetVSAMeas.isChecked()
	vsaDownRunChecked = self.ui.set_run_vsa.isChecked()
	downStack = self.ui.downStack_vsaMeas.currentIndex()
	vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
	if currentTab == 1:
		if downStack == 1:
			if vsaDownChecked == False and vsaDownRunChecked == False:
				if vsaChecked or vsaChecked_2:
					self.ui.vsaMeasNextStack.setCurrentIndex(2)
		else:
			if vsgType == 3: # vsg
				self.ui.vsaMeasNextStack.setCurrentIndex(6)
			else:
				self.ui.vsaMeasNextStack.setCurrentIndex(5)

def switchMeasTabVSG(self):
	currentTab = self.ui.vsgMeasParamTabs.currentIndex()
	awgChecked = self.ui.awgSet_vsgMeas.isChecked()
	awgRunChecked = self.ui.awgSetRun_vsgMeas.isChecked()
	upIdx = self.ui.upParamsStack_vsgMeas.currentIndex()
	noneChecked = self.ui.upSet_vsgMeas.isChecked()
	homoChecked = self.ui.homoRun.isChecked()
	heteroChecked = self.ui.heteroRun.isChecked()
	upEnabled = self.ui.vsgWorkflow_vsgMeas.currentIndex()
	if currentTab == 1:
		if upEnabled == 1 or upEnabled == 2:
			if awgChecked or awgRunChecked:
				if upIdx == 3 and homoChecked == False: # homo
					self.ui.vsgMeasNextStack.setCurrentIndex(7)
				elif upIdx == 1 and noneChecked == False: # none
					self.ui.vsgMeasNextStack.setCurrentIndex(7)
				elif upIdx == 2 and heteroChecked == False: # hetero
					self.ui.vsgMeasNextStack.setCurrentIndex(7)
		elif upEnabled == 0 or upEnabled == 3:
			self.ui.upParamsStack_vsgMeas.setCurrentIndex(4)
			if awgChecked or awgRunChecked:
				self.ui.vsgMeasNextStack.setCurrentIndex(8)
# called when tab in step 3 is changed (cal val, prechar, dpd)				
def switchAlgoTab(self,quality):
	currentTab = self.ui.algoTabs.currentIndex()
	safetyState = self.ui.actionEnable_Safety_Check.isChecked()
	if currentTab == 2:
		counterThree = tabCounterIncrement.counterThree
		if counterThree == 0 and safetyState:
			quality.exec_()
			tabCounterIncrement(self,"up")

def fileBrowse(self, lineEdit,path):
	fileInfo = str(QFileDialog.getOpenFileName(self,"Choose a File",path))
	fileList = fileInfo.split(",")
	file = fileList[0]
	file = file.replace("'","")
	file = file.replace("(","")
	lineEdit.clear()
	lineEdit.setText(file)
	
def fileSave(self,lineEdit,path):
	fileInfo = str(QFileDialog.getSaveFileName(self,'Save File Location',path,"Text Files (*.txt);;Matlab Files (*.mat)"))	
	fileList = fileInfo.split(",")
	file = fileList[0]
	file = file.replace("'","")
	file = file.replace("(","")
	if file != "":
		lineEdit.clear()
		lineEdit.setText(file)
		writeFile = open(file,'w')
		writeFile.close()
	
def fileOpen(self,lineEdit,path):
	file = str(QFileDialog.getExistingDirectory(self, "Select Directory", path))
	fileList = file.split(",")
	file = fileList[0]
	file = file.replace("'","")
	file = file.replace("(","")
	lineEdit.clear()
	lineEdit.setText(file)
# check to see that all parameters are filled out when set, if not, outline them in red
def checkIfDone(array):
	# check if any parameters are unfilled
	status = 1
	for key in array:
		#checks if a line edit has no text in the field and is enabled, then set the border to red (incomplete)
		if isinstance(key, QLineEdit) and key.text() == "" and key.isEnabled() == True:
			key.setStyleSheet("border: 1px solid red;")
			status = 0
		#same for qcomboboxes but checks if index is 0
		elif isinstance(key,QComboBox) and key.currentIndex() == 0 and key.isEnabled() == True:
			key.setStyleSheet("border: 1px solid red;")
			status = 0
		#else reset
		else:
			key.setStyleSheet(None)
	return status
	
def redock(self):
	self.ui.errorBar.setFloating(False)
	
def dockSettings(self):
	floatState = self.ui.errorBar.isFloating()
	if floatState:
		self.ui.errorScrollArea.setMaximumHeight(16777215)
	else:
		self.ui.errorScrollArea.setMaximumHeight(0)
		
##### TAKEN FROM: https://stackoverflow.com/questions/23279125/python-pyqt4-functions-to-save-and-restore-ui-widget-values	
def guisave(ui,settings):
	for name, obj in inspect.getmembers(ui):
		# if type(obj) is QComboBox:  # this works similar to isinstance, but missed some field... not sure why?
		if isinstance(obj, QComboBox):
			name = obj.objectName()  # get combobox name
			index = obj.currentIndex()  # get current index from combobox
			text = obj.itemText(index)  # get the text for current index
			settings.setValue(name, text)  # save combobox selection to registry

		if isinstance(obj, QLineEdit):
			name = obj.objectName()
			value = obj.text()
			settings.setValue(name, value)  # save ui values, so they can be restored next time

		if isinstance(obj, QCheckBox):
			name = obj.objectName()
			state = obj.isChecked()
			settings.setValue(name, state)
			
		if isinstance(obj, QRadioButton):
			name = obj.objectName()
			value = obj.isChecked()  # get stored value from registry
			settings.setValue(name, value)
			
		if isinstance(obj, QStackedWidget):
			name = obj.objectName()
			index = obj.currentIndex()
			settings.setValue(name, index)
			
def guirestore(ui,settings):
	for name, obj in inspect.getmembers(ui):
		if isinstance(obj, QComboBox):
			index = obj.currentIndex()  # get current region from combobox
			# text   = obj.itemText(index)   # get the text for new selected index
			name = obj.objectName()

			value = (settings.value(name))

			if value == "":
				continue

			index = obj.findText(value)  # get the corresponding index for specified string in combobox

			if index == -1:  # add to list if not found
				obj.insertItems(0, [value])
				index = obj.findText(value)
				obj.setCurrentIndex(index)
			else:
				obj.setCurrentIndex(index)  # preselect a combobox value by index

		if isinstance(obj, QLineEdit):
			name = obj.objectName()
			# value = (settings.value(name).decode('utf-8'))  # get stored value from registry
			value = settings.value(name)
			obj.setText(value)  # restore lineEditFile
			
		if isinstance(obj, QCheckBox):
			name = obj.objectName()
			value = settings.value(name)  # get stored value from registry
			if value != None:
				boolean = strToBool(value)
				obj.setChecked(boolean)  # restore checkbox
				
		if isinstance(obj, QRadioButton):
			name = obj.objectName()
			value = settings.value(name)  # get stored value from registry
			if value != None:
				boolean = strToBool(value)
				obj.setChecked(boolean)
		
		if isinstance(obj, QStackedWidget):
			name = obj.objectName()
			value = settings.value(name)
			if value != None:
				obj.setCurrentIndex(int(value))				

def strToBool(s):
    if s == 'true':
         return True
    elif s == 'false':
         return False
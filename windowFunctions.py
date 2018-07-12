# windowFunctions.py contains all the functions that are needed to control the window size, display, and menu functionality

from PyQt5.QtWidgets import (QMessageBox, QFileDialog, qApp,QDialog)
from PyQt5.QtGui import (QGuiApplication)
						 
def openDialog(self):
	fname = QFileDialog.getOpenFileName(self, 'Open file', '/home')
	if fname[0]:
		f = open(fname[0], 'r')
		with f:
			data = f.read()
			self.textEdit.setText(data)

def saveDialog(self):
	name=QFileDialog.getSaveFileName(self,'Save File')
	file = open(name,'w')
	text = self.textEdit.toPlainText()
	file.write(text)
	file.close()	
		
def closeButton(self):
	reply=QMessageBox.question(self,'Exit Confirmation',"Are you sure you want to close the program?",QMessageBox.Yes|QMessageBox.No,QMessageBox.No)
	if reply == QMessageBox.Yes:
		qApp.quit()	



def changeStepTab(self):
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
	if maxTrue == False:
		if i == 2:
			self.setMinimumSize(1265,650)
			self.resize(1265, 650)
			self.center()
		elif i == 1:
			# if safetyChecked:
				# self.setMinimumSize(1265,maxHeight)
				# self.resize(1265,maxHeight)
				# self.center()
			# else:
			self.initCheckUI()
			
		elif i == 0:
			self.setMinimumSize(1265,maxHeight)
			self.resize(1265,maxHeight)
			self.center()
		elif i == 3:
			self.setMinimumSize(1265,650)
			self.resize(1265,650)
			self.center()
	
def switchMeasTabVSA(self):
	currentTab = self.ui.vsaMeasParamTabs.currentIndex()
	vsaChecked = self.ui.vsaMeasSet.isChecked()
	vsaChecked_2 = self.ui.vsaMeasSet_2.isChecked()
	vsaDownChecked = self.ui.downSetVSAMeas.isChecked()
	vsaDownRunChecked = self.ui.set_run_vsa.isChecked()
	downStack = self.ui.downStack_vsaMeas.currentIndex()
	vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
	if currentTab == 0 or currentTab == 2:
		self.ui.calAdviceText.setVisible(False)
	elif currentTab == 1:
		if downStack == 1:
			self.ui.calAdviceText.setVisible(True)
			if vsaDownChecked == False and vsaDownRunChecked == False:
				if vsaChecked or vsaChecked_2:
					self.ui.vsaMeasNextStack.setCurrentIndex(2)
		else:
			self.ui.calAdviceText.setVisible(False)
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
				
def switchAlgoTab(self):
	currentTab = self.ui.algoTabs.currentIndex()

def fileBrowse(self, lineEdit,path):
	fileInfo = str(QFileDialog.getOpenFileName(self,"Choose a File",path))
	fileList = fileInfo.split(",")
	file = fileList[0]
	file = file.replace("'","")
	file = file.replace("(","")
	lineEdit.clear()
	lineEdit.setText(file)
	
def fileOpen(self, lineEdit):
	file = lineEdit.text()
	
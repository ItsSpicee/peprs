# contains all of the functions that are called when a debug button is clicked

# import classes
from PyQt5.QtWidgets import (QMessageBox)

# styling variables
greyHover = "QPushButton {border:3px solid rgb(0, 0, 127); background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:10px;color:black} QPushButton:hover{background-color:rgb(243, 243, 243);}"
blueSelect = "QPushButton{ border:3px solid rgb(0, 0, 127);  background-color:qlineargradient(spread:pad, x1:0.994318, y1:0.682, x2:1, y2:0, stop:0 rgba(72, 144, 216, 255), stop:1 rgba(83, 170, 252, 255)); border-radius:10px;color:white; font-weight:bold}"

def setParametersPrechar(self,matlab):
	# set all debug buttons grey
	setGreyPrecharButtons(self)
	# set selected debug button blue
	self.ui.setParameters_precharDebug.setStyleSheet(blueSelect)
	# run function
	matlab.Set_Parameters_PrecharDebug(nargout=0)
	# update with status bar message
	self.statusBar().showMessage('Successfully set parameters',2000)
	
def prepareSignalPrechar(self,matlab):
	setGreyPrecharButtons(self)
	self.ui.prepareSignal_precharDebug.setStyleSheet(blueSelect)
	matlab.Prepare_Signal_Upload_PrecharDebug(nargout=0)
	self.statusBar().showMessage('Successfully prepared signal for upload',2000)
	
def uploadSignalPrechar(self,matlab):
	setGreyPrecharButtons(self)
	self.ui.upload_precharDebug.setStyleSheet(blueSelect)
	error = matlab.Upload_Signal_PrecharDebug(nargout=1)
	# if an error occurred, alert
	if error != "":
		debugErrorMessage(self,error)
	else:
		self.statusBar().showMessage('Successfully uploaded signal',2000)
	
def downloadSignalPrechar(self,matlab):
	setGreyPrecharButtons(self)
	self.ui.download_precharDebug.setStyleSheet(blueSelect)
	error = matlab.Download_Signal_PrecharDebug(nargout=1)
	if error != "":
		debugErrorMessage(self,error)
	else:
		self.statusBar().showMessage('Successfully downloaded signal',2000)
	
def analyzeSignalPrechar(self,matlab):
	setGreyPrecharButtons(self)
	self.ui.analyze_precharDebug.setStyleSheet(blueSelect)
	error = matlab.Analyze_Signal_PrecharDebug(nargout=1)
	if error != "":
		debugErrorMessage(self,error)
	else:
		self.statusBar().showMessage('Successfully analyzed signal',2000)	
	
def saveDataPrechar(self,matlab):
	setGreyPrecharButtons(self)
	self.ui.saveData_precharDebug.setStyleSheet(blueSelect)
	error = matlab.Save_Data_PrecharDebug(nargout=1)
	if error != "":
		debugErrorMessage(self,error)
	else:
		self.statusBar().showMessage('Successfully saved data',2000)	
	
def saveMeasurementsPrechar(self,matlab):
	setGreyPrecharButtons(self)
	self.ui.saveMeasurements_precharDebug.setStyleSheet(blueSelect)
	result = matlab.Save_Measurements_PrecharDebug(nargout=1)
	# parse result for specific data
	result = result.split('~')
	error = result[0]
	nmsePercent = result[1]
	nmseDB = result[2]
	inputPAPR = result[3]
	outputPAPR = result[4]
	if error != "":
		debugErrorMessage(self,error)
	else:
		self.statusBar().showMessage('Successfully saved measurements',2000)	
	
######## FUNCTIONS USED WITHIN THIS FILE ########
# set all buttons to grey when new debug button is clicked
def setGreyPrecharButtons(self):
	self.ui.setParameters_precharDebug.setStyleSheet(greyHover)
	self.ui.prepareSignal_precharDebug.setStyleSheet(greyHover)
	self.ui.upload_precharDebug.setStyleSheet(greyHover)
	self.ui.download_precharDebug.setStyleSheet(greyHover)
	self.ui.analyze_precharDebug.setStyleSheet(greyHover)
	self.ui.saveData_precharDebug.setStyleSheet(greyHover)
	self.ui.saveMeasurements_precharDebug.setStyleSheet(greyHover)
	
def debugErrorMessage(self,error):
	msg = QMessageBox(self)
	msg.setIcon(QMessageBox.Critical)
	msg.setWindowTitle('Debug Error')
	msg.setText(error)
	msg.setStandardButtons(QMessageBox.Ok)
	msg.exec_();
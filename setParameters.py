# setParameters.py contains all the functions that are called whenever a "set" "set & run" or "preview" button is clicked

from PyQt5.QtWidgets import (QProgressBar,QMessageBox,QLabel,QPushButton)
from PyQt5.QtGui import (QCursor,QPixmap)
from PyQt5.QtCore import (Qt,QSize,QThread,pyqtSignal)

import windowFunctions as win

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.offsetbox import (OffsetImage, AnnotationBbox)
import matplotlib.image as mpimg
from main import matlab as matlab

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions used in main.py

incomplete = "QGroupBox{background-color:rgb(247, 247, 247); border:2px solid #f24646}"
redBorder = "QComboBox{background-color:rgb(247, 247, 247); border:2px solid #f24646}"

class runSignalGenerationThread(QThread):
	updateBar = pyqtSignal(object,str,QProgressBar,object)
	updateData = pyqtSignal(object,str)
	errorOccurred = pyqtSignal(object,str,object) 
	
	def __init__(self,bar,main,style):
		QThread.__init__(self)
		self.bar = bar
		self.main = main
		self.style = style
		
	def __del__(self):
		self.wait()
		
	def run(self):
		completed = "0"
		self.updateBar.emit(self.main,completed,self.bar,self.style)
		result = matlab.Set_Parameters_PrecharDebug(nargout=1)
		if result == "":
			completed = "1"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return
		result = matlab.Prepare_Signal_Upload_PrecharDebug(nargout=1)
		if result == "":
			completed = "2"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return	
		result = matlab.Upload_Signal_PrecharDebug(nargout=1)
		if result == "":
			completed = "3"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return		
		result = matlab.Download_Signal_PrecharDebug(nargout=1)
		if result == "":
			completed = "4"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return		
		result = matlab.Analyze_Signal_PrecharDebug(nargout=1)
		if result == "":
			completed = "5"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return	
		result = matlab.Save_Data_PrecharDebug(nargout=1)
		if result == "":
			completed = "6"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return
		result = matlab.Save_Measurements_PrecharDebug(nargout=1)
		resultSplit = result.split("~")
		if resultSplit[0] == "":
			self.updateData.emit(self.main,result)
			completed = "7"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return

class runHeterodyneCalibrationThread(QThread):
	updateBar = pyqtSignal(object,str,QProgressBar,object)
	#updateData = pyqtSignal(object,str)
	errorOccurred = pyqtSignal(object,str,object) 
	
	def __init__(self,bar,main,style):
		QThread.__init__(self)
		self.bar = bar
		self.main = main
		self.style = style
	
	def __del__(self):
		self.wait()
		
	def run(self):
		completed = "0"
		self.updateBar.emit(self.main,completed,self.bar,self.style)
		result = matlab.Set_Parameters_HeterodyneDebug(nargout=1)
		if result == "":
			completed = "1"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return
		result = matlab.Initialize_Drivers_HeterodyneDebug(nargout=1)
		if result == "":
			completed = "2"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return	
		result = matlab.Generate_Signal_HeterodyneDebug(nargout=1)
		if result == "":
			completed = "3"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return		
		result = matlab.Iterate_HeterodyneDebug(nargout=1)
		if result == "":
			completed = "7"
			self.updateBar.emit(self.main,completed,self.bar,self.style)
		else:
			self.errorOccurred.emit(self.main,result,self.bar)
			return		
		# result = matlab.Analyze_Signal_PrecharDebug(nargout=1)
		# if result == "":
			# completed = "5"
			# self.updateBar.emit(self.main,completed,self.bar,self.style)
		# else:
			# self.errorOccurred.emit(self.main,result,self.bar)
			# return	
		# result = matlab.Save_Data_PrecharDebug(nargout=1)
		# if result == "":
			# completed = "6"
			# self.updateBar.emit(self.main,completed,self.bar,self.style)
		# else:
			# self.errorOccurred.emit(self.main,result,self.bar)
			# return
		# result = matlab.Save_Measurements_PrecharDebug(nargout=1)
		# resultSplit = result.split("~")
		# if resultSplit[0] == "":
			# self.updateData.emit(self.main,result)
			# completed = "7"
			# self.updateBar.emit(self.main,completed,self.bar,self.style)
		# else:
			# self.errorOccurred.emit(self.main,result,self.bar)
			# return
			
def setGeneralAWG(self,buttonFocus,boxDone,greyHover,buttonSelected,greyButton,awgSetGeneral,matlab):
	#Array used instead of dictionary, cannot properly get the object type elements stored in a dict
	checkDic = [
		self.ui.address_awg,
		self.ui.refClockSorce_awg,
		self.ui.extRefFreq_awg,
		self.ui.model_awg,
		self.ui.iChannel_awg,
		self.ui.qChannel_awg,
		self.ui.maxSampleRate_awg
	]

	flag = 0
	if awgSetGeneral.isChecked() == True:
		#one single call to a windowfunctions.py function
		done = win.checkIfDone(checkDic)
		if done:
			# call matlab instrument code
			d={
				"address": self.ui.address_awg.text(),
				"refClkSrc": self.ui.refClockSorce_awg.currentIndex(),
				"refClkFreq": self.ui.extRefFreq_awg.text(),
				"model": self.ui.model_awg.currentIndex()
			}
			iChannel = self.ui.iChannel_awg.currentIndex()
			qChannel = self.ui.qChannel_awg.currentIndex()
			if iChannel == 0 or qChannel == 0:
				instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			else:
				# matlab.Set_Channel_Mapping(iChannel,qChannel,"RX",nargout=0)
				# matlab.Set_Channel_Mapping(iChannel,qChannel,"AWG",nargout=0)
				flag = setAWGParams(self,d,matlab)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			awgSetGeneral.setChecked(False)
		
		if flag:
			self.ui.awgButton_vsg.setStyleSheet(buttonFocus)
			self.ui.awgButton_vsg_2.setStyleSheet(buttonFocus)
			self.ui.awgButton_vsg_3.setStyleSheet(buttonFocus)
			self.ui.awgEquipGeneral.setStyleSheet(boxDone)
			awgSetGeneral.setText("Unset")
			setupIdx = self.ui.vsgWorkflows.currentIndex()
			if setupIdx == 1:
				self.ui.vsgNextSteps.setCurrentIndex(5)
				self.ui.vsaButton_vsg.setStyleSheet(greyHover)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			elif setupIdx == 2:
				self.ui.vsgNextSteps.setCurrentIndex(2)
				self.ui.vsgNextSteps.setCurrentIndex(2)
				self.ui.upButton_vsg.setStyleSheet(greyHover)
				self.ui.upButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
				self.ui.psgButton_vsg.setStyleSheet(greyHover)
				self.ui.psgButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			elif setupIdx == 3:
				self.ui.vsgNextSteps.setCurrentIndex(3)
				self.ui.upButton_vsg.setStyleSheet(greyHover)
				self.ui.upButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
				self.ui.psgButton_vsg.setStyleSheet(greyHover)
				self.ui.psgButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		
	elif awgSetGeneral.isChecked() == False:
		self.ui.awgEquipGeneral.setStyleSheet(None)
		self.ui.awgButton_vsg.setStyleSheet(buttonSelected)
		self.ui.awgButton_vsg_2.setStyleSheet(buttonSelected)
		self.ui.awgButton_vsg_3.setStyleSheet(buttonSelected)
		self.ui.vsaButton_vsg.setStyleSheet(greyButton)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		self.ui.upButton_vsg.setStyleSheet(greyButton)
		self.ui.upButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		self.ui.psgButton_vsg.setStyleSheet(greyButton)
		self.ui.psgButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		self.ui.vsgNextSteps.setCurrentIndex(1)
		awgSetGeneral.setText("Set")
		
def setAdvancedAWG(self,boxDone,setButton,matlab):
	checkDic=[
		self.ui.trigMode_awg,
		self.ui.dacRange_awg,
		self.ui.sampleMarker_awg,
		self.ui.syncMarker_awg,
	]
	
	d={
		"address": self.ui.address_awg.text(),
		"trigMode": self.ui.trigMode_awg.currentIndex(),
		"dacRange": self.ui.dacRange_awg.text(),
		"syncMarker": self.ui.syncMarker_awg.text(),
		"sampleMarker": self.ui.sampleMarker_awg.text(),
		"genSet": self.ui.awgSetGeneral.isChecked()
	}
	flag = setAdvAWGParams(self,d,matlab)
	
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			if flag == 1:
				setButton.setText("Unset")
				self.ui.awgEquipAdv.setStyleSheet(boxDone)
				self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)			
	elif setButton.isChecked() == False:
		self.ui.awgEquipAdv.setStyleSheet(None)
		setButton.setText("Set")
		
def setGeneralVSG(self,buttonFocus,boxDone,greyHover,buttonSelected,greyButton,vsgSetGeneral):
	checkDic=[
		self.ui.refClockSorce_vsg,
		self.ui.extRefFreq_vsg,
		self.ui.iChannel_vsg,
		self.ui.qChannel_vsg,
		self.ui.model_vsg,
		self.ui.address_vsg,
		self.ui.maxSampleRate_vsg
		
	]

	if vsgSetGeneral.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			vsgSetGeneral.setText("Unset")
			self.ui.vsgButton_vsg.setStyleSheet(buttonFocus)
			self.ui.vsgEquipGeneral.setStyleSheet(boxDone)
			self.ui.vsgNextSteps.setCurrentIndex(5)
			self.ui.vsaButton_vsg.setStyleSheet(greyHover)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			vsgSetGeneral.setChecked(False)
	elif  vsgSetGeneral.isChecked() == False:
		self.ui.vsgEquipGeneral.setStyleSheet(None)
		self.ui.vsgButton_vsg.setStyleSheet(buttonSelected)
		self.ui.vsgNextSteps.setCurrentIndex(4)
		self.ui.vsaButton_vsg.setStyleSheet(greyButton)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		vsgSetGeneral.setText("Set")

def setAdvanced(self,box,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
		box.setStyleSheet(boxDone)
		self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)
	elif setButton.isChecked() == False:
		box.setStyleSheet(None)
		setButton.setText("Set")
		
def setUp(self,buttonFocus,buttonDone,boxDone,greyHover,greyButton,buttonSelect,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
		self.ui.upButton_up.setStyleSheet(buttonFocus)
		self.ui.upButton_vsg.setStyleSheet(buttonDone)
		self.ui.upEquip.setStyleSheet(boxDone)
		self.ui.up_psg_next.setCurrentIndex(2)
		self.ui.vsgNextSteps.setCurrentIndex(5)
		self.ui.vsaButton_up.setStyleSheet(greyHover)
		self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.vsaButton_vsg.setStyleSheet(greyHover)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	elif setButton.isChecked() == False:
		self.ui.upEquip.setStyleSheet(None)
		self.ui.upButton_up.setStyleSheet(buttonSelect)
		self.ui.upButton_vsg.setStyleSheet(greyHover)
		self.ui.upButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.up_psg_next.setCurrentIndex(0)
		self.ui.vsgNextSteps.setCurrentIndex(2)
		self.ui.vsaButton_up.setStyleSheet(greyButton)
		self.ui.vsaButton_up.setCursor(QCursor(Qt.ArrowCursor))
		self.ui.vsaButton_vsg.setStyleSheet(greyButton)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		setButton.setText("Set")
			
def setPSG(self,buttonFocus,buttonDone,boxDone,greyHover,greyButton,buttonSelect,setButton):
	if setButton.isChecked() == True:
		statusList = [1]
		setButton.setText("Unset")
		self.ui.psgButton_up.setStyleSheet(buttonFocus)
		self.ui.psgButton_vsg.setStyleSheet(buttonDone)
		self.ui.psgEquip.setStyleSheet(boxDone)
		self.ui.up_psg_next.setCurrentIndex(2)
		self.ui.vsgNextSteps.setCurrentIndex(5)
		self.ui.vsaButton_up.setStyleSheet(greyHover)
		self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.vsaButton_vsg.setStyleSheet(greyHover)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	elif setButton.isChecked() == False:
		self.ui.psgEquip.setStyleSheet(None)
		self.ui.psgButton_up.setStyleSheet(buttonSelect)
		self.ui.psgButton_vsg.setStyleSheet(greyHover)
		self.ui.psgButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.up_psg_next.setCurrentIndex(1)
		self.ui.vsgNextSteps.setCurrentIndex(3)
		self.ui.vsgNextSteps.setCurrentIndex(3)
		self.ui.vsaButton_up.setStyleSheet(greyButton)
		self.ui.vsaButton_up.setCursor(QCursor(Qt.ArrowCursor))
		self.ui.vsaButton_vsg.setStyleSheet(greyButton)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		setButton.setText("Set")
		
def setVSA(self,buttonFocus,setButtonHover,boxDone,greyHover,greyButton,buttonSelect,setButton,matlab):
	# define variables
	averaging = self.ui.averagingEnable.currentIndex()
	avgEnabled = self.ui.averagingEnable.isEnabled()
	demod = self.ui.demodulationEnable.currentIndex()
	typeIdx = self.ui.vsaType.currentIndex()
	flag = 0;
	
	# make averaging and demodulation enabled grey to get a fresh start
	self.ui.averagingEnable.setStyleSheet(None)
	self.ui.demodulationEnable.setStyleSheet(None)
	
	# if all top vsa parameters are filled out
	if setButton.isChecked() == True:
		if averaging != 0 or avgEnabled == False:
			self.ui.averagingEnable.setStyleSheet(None)
			if demod != 0:
				self.ui.demodulationEnable.setStyleSheet(None)
				if typeIdx == 3 or typeIdx == 4: # UXA & PXA
					checkDic=[
						self.ui.averagingEnable,
						self.ui.demodulationEnable,
						self.ui.vsaType,
						self.ui.noAveragesField_sa,
						self.ui.attenuation_sa,
						self.ui.freq_sa,
						self.ui.analysisBandwidth_sa,
						self.ui.clockRef_sa,
						self.ui.trigLevel_sa,
						self.ui.trigSource_sa,
						self.ui.address_sa,
						self.ui.dllFile_uxa,
						self.ui.setupFile_uxa,
						self.ui.dataFile_uxa
					]
					done = win.checkIfDone(checkDic)
					if done:
						dAllUXA={
							"averaging" : self.ui.averagingEnable.currentIndex(),
							"noAverages": self.ui.noAveragesField_sa.text(),
							"atten": self.ui.attenuation_sa.text(),
							"freq": self.ui.freq_sa.text(),
							"analysisBW": self.ui.analysisBandwidth_sa.text(),
							"clockRef": self.ui.clockRef_sa.currentIndex(),
							"trigLevel": self.ui.trigLevel_sa.text(),
							"trigSource": self.ui.trigSource_sa.currentIndex(),
							"address": self.ui.address_sa.text()	
						}
						if typeIdx == 3:
							result = matlab.Set_VSA_UXA(dAllUXA,"UXA",nargout=1)
						elif typeIdx == 4:
							result = matlab.Set_VSA_UXA(dAllUXA,"PXA",nargout=1)
						result = result.split("~")
						partNum = result[0]
						errorString = result[1]
						errorArray = errorString.split("|")
						errors = determineIfErrors(self,errorArray)
						if errors == 0:
							self.ui.partNum_sa.setText(partNum);
							flag = 1;
						else:
							addToErrorLayout(self,errorArray)
							self.ui.awgSetGeneral.setChecked(False)
							
						if flag:
							setButton.setText("Unset")
							
							# style mod related widgets
							self.ui.uxaEquipGeneralVSA.setStyleSheet(boxDone)
							demod = self.ui.uxaMod.isEnabled()
							if demod:
								setAllDemod(self,boxDone)
								self.ui.modButton_vsa.setStyleSheet(buttonFocus)
							self.ui.vsaNextStack.setCurrentIndex(3)
							self.ui.vsgNextSteps.setCurrentIndex(7)
							self.ui.up_psg_next.setCurrentIndex(5)
							if typeIdx == 3: #UXA
								self.ui.uxaButton_vsa.setStyleSheet(buttonFocus)
								self.ui.uxaButton_vsa_2.setStyleSheet(buttonFocus)
								setPrevVSAButtons(self,setButtonHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor,greyHover,Qt.PointingHandCursor)			
							elif typeIdx == 4: #PXA
								self.ui.pxaButton_vsa.setStyleSheet(buttonFocus)
								self.ui.pxaButton_vsa_2.setStyleSheet(buttonFocus)
								setPrevVSAButtons(self,setButtonHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor,greyHover,Qt.PointingHandCursor)
					else:
						instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
						setButton.setChecked(False)
				elif typeIdx == 1 or typeIdx == 2 or typeIdx == 5 or typeIdx == 6:
					
				
					setButton.setText("Unset")
						
					if typeIdx == 1 or typeIdx == 5: #Scope
						
						checker = [
							self.ui.averagingEnable,
							self.ui.demodulationEnable,
							self.ui.vsaType,
							
							self.ui.noAveragesField_scope,
							self.ui.extClkEnabled_scope,
							self.ui.trigChannel_scope,
							self.ui.driverPath_scope,
							self.ui.acquisition_scope,
							self.ui.address_scope,
							self.ui.dllFile_scope,
							self.ui.setupFile_scope,
							self.ui.dataFile_scope
						]
						done = win.checkIfDone(checker)
						if done:
							demodScope = self.ui.scopeMod.isEnabled()
							demodDig = self.ui.digMod.isEnabled()
							if demodScope or demodDig:
								setAllDemod(self,boxDone)
								self.ui.modButton_vsa_2.setStyleSheet(buttonFocus)
								self.ui.modButton_vsa.setStyleSheet(buttonFocus)
							self.ui.scopeEquipGeneral.setStyleSheet(boxDone)
							self.ui.scopeButton_vsa.setStyleSheet(buttonFocus)
							self.ui.scopeButton_vsa_2.setStyleSheet(buttonFocus)
							self.ui.scopeButton_vsa_3.setStyleSheet(buttonFocus)
							self.ui.scopeButton_vsa_4.setStyleSheet(buttonFocus)
							if typeIdx == 1:
								self.ui.vsaNextStack.setCurrentIndex(3)
								self.ui.vsgNextSteps.setCurrentIndex(7)
								self.ui.up_psg_next.setCurrentIndex(5)
								setPrevVSAButtons(self,setButtonHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor,greyHover,Qt.PointingHandCursor)
							elif typeIdx == 5:
								self.ui.vsaNextStack.setCurrentIndex(2)
								self.ui.vsgNextSteps.setCurrentIndex(6)
								self.ui.up_psg_next.setCurrentIndex(4)
								setPrevVSAButtons(self,setButtonHover,Qt.PointingHandCursor,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor)
						else:
							instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
							setButton.setChecked(False)
					elif typeIdx == 2 or typeIdx ==6: #Digitizer
						checkah=[
							self.ui.averagingEnable,
							self.ui.demodulationEnable,
							self.ui.vsaType,
							
							self.ui.refSource_dig,
							self.ui.trigSource_dig,
							self.ui.trigLevel_dig,
							self.ui.clockEnabled_dig,
							self.ui.clockFreq_dig,
							self.ui.coupling_dig,
							self.ui.vfs_dig,
							self.ui.interleaving_dig,
							self.ui.c1Interleave_dig,
							self.ui.c2Interleave_dig,
							self.ui.address_dig,
							self.ui.dllFile_dig,
							self.ui.setupFile_dig,
							self.ui.dataFile_dig
						]
						done = win.checkIfDone(checkah)
						if done:
							demodScope = self.ui.scopeMod.isEnabled()
							demodDig = self.ui.digMod.isEnabled()
							if demodScope or demodDig:
								setAllDemod(self,boxDone)
								self.ui.modButton_vsa_2.setStyleSheet(buttonFocus)
								self.ui.modButton_vsa.setStyleSheet(buttonFocus)
							self.ui.digEquipGeneral.setStyleSheet(boxDone)
							self.ui.digButton_vsa.setStyleSheet(buttonFocus)
							self.ui.digButton_vsa_2.setStyleSheet(buttonFocus)
							self.ui.digButton_vsa_3.setStyleSheet(buttonFocus)
							self.ui.digButton_vsa_4.setStyleSheet(buttonFocus)
							if typeIdx == 2:
								self.ui.vsaNextStack.setCurrentIndex(3)
								self.ui.vsgNextSteps.setCurrentIndex(7)
								self.ui.up_psg_next.setCurrentIndex(5)
								setPrevVSAButtons(self,setButtonHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor,greyHover,Qt.PointingHandCursor)
							elif typeIdx == 6:
								self.ui.vsaNextStack.setCurrentIndex(2)
								self.ui.vsgNextSteps.setCurrentIndex(6)
								self.ui.up_psg_next.setCurrentIndex(4)
								setPrevVSAButtons(self,setButtonHover,Qt.PointingHandCursor,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor)
						else:
							instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
							setButton.setChecked(False)
				# general step 3 vsa parameters
				fSampleField = ""
				vsaPage = self.ui.vsaMeasGenStack.currentIndex()
				if vsaPage == 1:
					fSampleField = self.ui.sampRate_vsaMeas.text()
				elif vsaPage == 0:
					fSampleField = self.ui.sampRate_vsaMeas_2.text()
				
				channelVec = [0,0,0,0]
				c1 = self.ui.measChannel1.isChecked()
				c2 = self.ui.measChannel2.isChecked()
				c3 = self.ui.measChannel3.isChecked()
				c4 = self.ui.measChannel4.isChecked()
				if c1:
					channelVec[0] = 1
				elif c1 == False:
					channelVec[0] = 0
				if c2:
					channelVec[1] = 1
				elif c2 == False:
					channelVec[1] = 0
				if c3:
					channelVec[2] = 1
				elif c3 == False:
					channelVec[2] = 0
				if c4:
					channelVec[3] = 1
				elif c4 == False:
					channelVec[3] = 0
					
				dGen = {
					"AnalysisBandwidth":self.ui.analysisBandwidth_sa.text(),
					"Attenuation":self.ui.attenuation_sa.text(),
					"ClockReference":self.ui.clockRef_sa.currentIndex(),
					"TriggerLevel":self.ui.trigLevel_sa.text(),
					"Interleaving" : self.ui.interleaving_dig.currentIndex(),
					"EnableExternalClock_Dig" : self.ui.clockEnabled_dig.currentIndex(),
					"ExternalClockFrequency" : self.ui.clockFreq_dig.currentIndex(),
					"VFS" : self.ui.vfs_dig.text(),
					"ACDCCoupling" : self.ui.coupling_dig.currentIndex(),
					"DriverPath" : self.ui.driverPath_scope.text(),
					"EnableExternalClock_Scope" : self.ui.extClkEnabled_scope.currentIndex(),
					"ChannelVec": channelVec,
					"FSample": fSampleField
				}
				matlab.SetRxParameters_GUI(dGen,nargout=0);
				
			else:
				self.fillParametersMsg()
				# highlight parameters in dark blue section if necessary
				self.ui.demodulationEnable.setStyleSheet(redBorder)
				if averaging == 0 and avgEnabled == True:
					self.ui.averagingEnable.setStyleSheet(redBorder)
				self.ui.digSet.setChecked(False)
				self.ui.scopeSet.setChecked(False)
				self.ui.uxaSet.setChecked(False)
				self.ui.pxaSet.setChecked(False)
				
		else:
			self.fillParametersMsg()
			# highlight parameters in red in dark blue section if necessary
			self.ui.averagingEnable.setStyleSheet(redBorder)
			if demod == 0:
				self.ui.demodulationEnable.setStyleSheet(redBorder)
			self.ui.digSet.setChecked(False)
			self.ui.scopeSet.setChecked(False)
			self.ui.uxaSet.setChecked(False)
			self.ui.pxaSet.setChecked(False)
			
	elif setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.vsaNextStack.setCurrentIndex(1)
		self.ui.vsgNextSteps.setCurrentIndex(5)
		self.ui.up_psg_next.setCurrentIndex(3)
		setPrevVSAButtons(self,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor,greyButton,Qt.ArrowCursor)
		self.ui.modButton_vsa_2.setStyleSheet(buttonSelect)
		self.ui.modButton_vsa.setStyleSheet(buttonSelect)
		if typeIdx == 1 or typeIdx == 5:
			self.ui.scopeButton_vsa.setStyleSheet(buttonSelect)
			self.ui.scopeButton_vsa_2.setStyleSheet(buttonSelect)
			self.ui.scopeButton_vsa_3.setStyleSheet(buttonSelect)
			self.ui.scopeButton_vsa_4.setStyleSheet(buttonSelect)
			self.ui.scopeEquipGeneral.setStyleSheet(None)	
			self.ui.scopeMod.setStyleSheet(None)
		elif typeIdx == 2 or typeIdx == 6:
			self.ui.digButton_vsa.setStyleSheet(buttonSelect)
			self.ui.digButton_vsa_2.setStyleSheet(buttonSelect)
			self.ui.digButton_vsa_3.setStyleSheet(buttonSelect)
			self.ui.digButton_vsa_4.setStyleSheet(buttonSelect)
			self.ui.digEquipGeneral.setStyleSheet(None)
			self.ui.digMod.setStyleSheet(None)
		elif typeIdx == 3:
			self.ui.uxaButton_vsa.setStyleSheet(buttonSelect)
			self.ui.uxaButton_vsa_2.setStyleSheet(buttonSelect)
			self.ui.uxaEquipGeneralVSA.setStyleSheet(None)
			self.ui.uxaMod.setStyleSheet(None)
		elif typeIdx == 4:
			self.ui.pxaButton_vsa.setStyleSheet(buttonSelect)
			self.ui.pxaButton_vsa_2.setStyleSheet(buttonSelect)		
			self.ui.uxaEquipGeneralVSA.setStyleSheet(None)
			self.ui.uxaMod.setStyleSheet(None)
		
def setVSAAdv(self,boxDone,setButton,matlab):
	flag = 0;
	if setButton.isChecked() == True:
		averaging = self.ui.averagingEnable.currentIndex()
		demod = self.ui.demodulationEnable.currentIndex()
		if averaging != 0 and demod != 0:
			d = {
				"address": self.ui.address_sa.text(),
				"preamp": self.ui.preampEnable_vsa.currentIndex(),
				"ifPath": self.ui.ifPath_vsa.currentIndex(),
				"mwPath": self.ui.mwPath_vsa.currentIndex(),
				"phaseNoise": self.ui.phaseNoiseOptimization_vsa.currentIndex(),
				"filterType": self.ui.filterTpye_vsa.currentIndex()
			}
			result = matlab.Set_VSA_AdvUXA(d,nargout = 1)
			result = result.split("~")
			partNum = result[0]
			errorString = result[1]
			errorArray = errorString.split("|")
			errors = determineIfErrors(self,errorArray)
			if errors == 0:
				self.ui.partNum_sa.setText(partNum);
				flag = 1;
			else:
				addToErrorLayout(self,errorArray)
				self.ui.awgSetGeneral.setChecked(False)
			
			if flag:
				self.ui.uxaVSAAdv.setStyleSheet(boxDone)
				setButton.setText("Unset")
				self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)
		else:
			self.fillParametersMsg()
			self.ui.uxaVSASetAdv.setChecked(False)
	elif  setButton.isChecked() == False:
		self.ui.uxaVSAAdv.setStyleSheet(None)
		setButton.setText("Set")
		
def setDown(self,buttonFocus,greyHover,buttonHover,boxDone,greyButton,buttonSelect,setButton):
	checkDic = [
		self.ui.comboBox_58,
		self.ui.lineEdit_47,
		self.ui.lineEdit_48
	]
	done = win.checkIfDone(checkDic)
	if setButton.isChecked() == True:
		if done:
			setButton.setText("Unset")
			self.ui.downButton_down.setStyleSheet(buttonFocus)
			self.ui.downButton_down_2.setStyleSheet(buttonFocus)
			self.ui.downEquip.setStyleSheet(boxDone)
			setPrevDownButtons(self,buttonHover,Qt.PointingHandCursor,greyHover,Qt.PointingHandCursor)
			self.ui.downNextStack.setCurrentIndex(1)
			self.ui.vsaNextStack.setCurrentIndex(3)
			self.ui.up_psg_next.setCurrentIndex(5)
			self.ui.vsgNextSteps.setCurrentIndex(7)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
	elif setButton.isChecked() == False:
		self.ui.downEquip.setStyleSheet(None)
		self.ui.downButton_down.setStyleSheet(buttonSelect)
		self.ui.downButton_down_2.setStyleSheet(buttonSelect)
		setPrevDownButtons(self,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor)
		self.ui.downNextStack.setCurrentIndex(0)
		self.ui.vsaNextStack.setCurrentIndex(2)
		self.ui.up_psg_next.setCurrentIndex(4)
		self.ui.vsgNextSteps.setCurrentIndex(6)
		setButton.setText("Set")
		
def setMeter(self,buttonFocus,buttonHover,greyHover,boxDone,greyButton,buttonSelect,setButton,matlab):
	checkMeter={
			self.ui.powerMeterAddress,
			self.ui.powerMeterOffset,
			self.ui.powerMeterFrequency,
			self.ui.powerMeterFilter
		}

	if setButton.isChecked() == True:
		completed = win.checkIfDone(checkMeter)
		if completed:
			flag = 0;
			setButton.setText("Unset")
			averaging = ""
			if self.ui.powerMeterFilter.currentIndex() == 1:
				averaging = "-1"
			elif self.ui.powerMeterFilter.currentIndex() == 3:
				averaging = "-2"
			elif self.ui.powerMeterFilter.currentIndex() == 2:
				averaging = self.ui.noAveragesField_meter.text()
			
			d={
				"address": 	self.ui.powerMeterAddress.text(),
				"offset": self.ui.powerMeterOffset.text(),
				"frequency": self.ui.powerMeterFrequency.text(),
				"averaging": averaging
			}
			flag = setPowerMeterParams(self,d,self.ui.powerMeterPartNum,self.ui.meterEquip,boxDone,matlab)
			
			self.ui.meterButton_meter.setStyleSheet(buttonFocus)
			self.ui.meterButton_meter_2.setStyleSheet(buttonFocus)
			self.ui.meterButton_meter_3.setStyleSheet(buttonFocus)
			self.ui.meterButton_meter_4.setStyleSheet(buttonFocus)
			setPrevMeterButtons(self,buttonHover,Qt.PointingHandCursor,greyHover,Qt.PointingHandCursor)
			self.ui.meterEquip.setStyleSheet(boxDone)
			self.ui.meterNextStack.setCurrentIndex(1)
			self.ui.downNextStack.setCurrentIndex(2)
			self.ui.vsaNextStack.setCurrentIndex(4)
			self.ui.up_psg_next.setCurrentIndex(6)
			self.ui.vsgNextSteps.setCurrentIndex(8)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			#setButton.setChecked(False)
	elif setButton.isChecked() == False:
		self.ui.meterEquip.setStyleSheet(None)
		self.ui.meterButton_meter.setStyleSheet(buttonSelect)
		self.ui.meterButton_meter_2.setStyleSheet(buttonSelect)
		self.ui.meterButton_meter_3.setStyleSheet(buttonSelect)
		self.ui.meterButton_meter_4.setStyleSheet(buttonSelect)
		setPrevMeterButtons(self,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor)
		self.ui.meterNextStack.setCurrentIndex(0)
		self.ui.downNextStack.setCurrentIndex(1)
		self.ui.vsaNextStack.setCurrentIndex(3)
		self.ui.up_psg_next.setCurrentIndex(5)
		self.ui.vsgNextSteps.setCurrentIndex(7)
		setButton.setText("Set")
		

def setSA(self,buttonFocus,buttonHover,greyHover,boxDone,setButton,greyButton,buttonSelect,matlab):
	idx = self.ui.saType.currentIndex()
	
	checkDic=[
		self.ui.address_spa,
		self.ui.freq_spa,
		self.ui.freqSpan_spa,
		self.ui.resBand_spa,
		self.ui.clockRef_spa,
		self.ui.trigLevel_spa,
		self.ui.trigSource_spa
		]
	
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			statusList = [self.ui.address_spa.text(),self.ui.freq_spa.text(),self.ui.freqSpan_spa.text(),self.ui.resBand_spa.text(),self.ui.clockRef_spa.currentIndex()]
			#complete = win.checkIfDone(statusList)
			d={
				"address": self.ui.address_spa.text(),
				"atten": self.ui.attenuation_spa.text(),
				"freq": self.ui.freq_spa.text(),
				"freqSpan": self.ui.freqSpan_spa.text(),
				"resBand": self.ui.resBand_spa.text(),
				"clockRef": self.ui.clockRef_spa.currentIndex(),
				"trigLevel": self.ui.trigLevel_spa.text(),
				"trigger": self.ui.trigSource_spa.currentIndex()
			}	
			#if complete:
			if idx == 1:
				model = "UXA";
			elif idx == 2:
				model == "PXA"
			flag = setSpectrumAnalyzerParams(self,d,self.ui.partNum_spa,matlab,self.ui.saEquip,boxDone,model)
			self.ui.saButton_sa.setStyleSheet(buttonFocus)
			self.ui.saButton_sa_2.setStyleSheet(buttonFocus)
			self.ui.saButton_sa_3.setStyleSheet(buttonFocus)
			self.ui.saButton_sa_4.setStyleSheet(buttonFocus)
			setPrevSAButtons(self,buttonHover,Qt.PointingHandCursor,greyHover,Qt.PointingHandCursor)
			self.ui.saEquip.setStyleSheet(boxDone)
			self.ui.saNextStack.setCurrentIndex(0)
			self.ui.meterNextStack.setCurrentIndex(2)
			self.ui.downNextStack.setCurrentIndex(3)
			self.ui.vsaNextStack.setCurrentIndex(5)
			self.ui.up_psg_next.setCurrentIndex(7)
			self.ui.vsgNextSteps.setCurrentIndex(9)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
	elif setButton.isChecked() == False:
		self.ui.saEquip.setStyleSheet(None)
		self.ui.saButton_sa.setStyleSheet(buttonSelect)
		self.ui.saButton_sa_2.setStyleSheet(buttonSelect)
		self.ui.saButton_sa_3.setStyleSheet(buttonSelect)
		self.ui.saButton_sa_4.setStyleSheet(buttonSelect)
		setPrevSAButtons(self,greyHover,Qt.PointingHandCursor,greyButton,Qt.ArrowCursor)
		self.ui.saNextStack.setCurrentIndex(4)
		self.ui.meterNextStack.setCurrentIndex(1)
		self.ui.downNextStack.setCurrentIndex(2)
		self.ui.vsaNextStack.setCurrentIndex(4)
		self.ui.up_psg_next.setCurrentIndex(6)
		self.ui.vsgNextSteps.setCurrentIndex(8)
		setButton.setText("Set")
		
def setSAAdv(self,buttonFocus,buttonHover,greyHover,boxDone,setButton,greyButton,buttonSelect,matlab):
	checkDic={
			self.ui.address_spa,
			self.ui.saScrenName_spa,
			self.ui.acpScreenName_spa,
			self.ui.preampEnable_spa,
			self.ui.traceNum_spa,
			self.ui.traceAvg_spa,
			#self.ui.traceAvgCount_spa,
			self.ui.noiseExtension_spa,
			self.ui.acpNoiseEnable_spa,
			self.ui.acpBW_spa,
			self.ui.acpOffset_spa,
			self.ui.lowNoisePath_spa,
			self.ui.averaging_spa,
			self.ui.avgCount_spa,
			self.ui.filterType_spa,
			self.ui.detector_spa,
			self.ui.detector_spa
		}
		
	if setButton.isChecked() == True:
		flag = 0;
		done = win.checkIfDone(checkDic)
		if done:
			d ={
				"address": self.ui.address_spa.text(),
				"SAScreen": self.ui.saScrenName_spa.text(),
				"ACPScreen": self.ui.acpScreenName_spa.text(),
				"preAmp": self.ui.preampEnable_spa.currentIndex(),
				"traceNum" : self.ui.traceNum_spa.text(),
				"traceAvg": self.ui.traceAvg_spa.currentIndex(),
				#"traceAvgNum": self.ui.traceAvgCount_spa.text(),
				"noiseExtension": self.ui.noiseExtension_spa.currentIndex(),
				"ACPCorrection": self.ui.acpNoiseEnable_spa.currentIndex(),
				"ACPBand": self.ui.acpBW_spa.text(),
				"ACPOffset": self.ui.acpOffset_spa.text(),
				"mw": self.ui.lowNoisePath_spa.currentIndex(),
				"phaseNoise": self.ui.noiseOptimization_spa.currentIndex(),
				"averaging": self.ui.averaging_spa.currentIndex(),
				"avgCount": self.ui.avgCount_spa.text(),
				"filterType": self.ui.filterType_spa.currentIndex(),
				"detector": self.ui.detector_spa.currentIndex()
			}
			
			setButton.setText("Unset")
			self.ui.saEquipAdv.setStyleSheet(boxDone)
			
			flag = setSpectrumAnalyzerAdvancedParams(self,d,self.ui.saEquipAdv,matlab,boxDone)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
		
		if flag:
			setButton.setText("Unset")
			self.ui.saEquipAdv.setStyleSheet(boxDone)
		
	elif setButton.isChecked() == False:
		self.ui.saEquipAdv.setStyleSheet(None)
		setButton.setText("Set")
		
		
def setP1(self,boxDone,buttonFocus,buttonHover,greyHover,greyButton,matlab,buttonSelect,setButton):
	checkDic = [
		self.ui.p1c1Address,
		self.ui.p1c1Voltage,
		self.ui.p1c1Current,
		self.ui.p1c2Address,
		self.ui.p1c2Voltage,
		self.ui.p1c2Current,
		self.ui.p1c3Address,
		self.ui.p1c3Voltage,
		self.ui.p1c3Current,
		self.ui.p1c4Address,
		self.ui.p1c4Voltage,
		self.ui.p1c4Current,
		self.ui.p1Enabled,
		self.ui.noChannels_p1
	]
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			flag = 0;
			numberChannels = self.ui.noChannels_p1.currentIndex()
			vsgType = self.ui.vsgSetup.currentIndex()
			vsaType = self.ui.vsaType.currentIndex()
			enabledSupply = self.ui.p1Enabled.currentIndex()
			p1c1A = self.ui.p1c1Address.text()
			p1c2A = self.ui.p1c2Address.text()
			p1c3A = self.ui.p1c3Address.text()
			p1c4A = self.ui.p1c4Address.text()
			
			# set instrument params
			if enabledSupply == 0 or enabledSupply == 2:
				if enabledSupply == 2:
					flag = 1;
				if p1c1A != "":
					matlab.Output_Toggle(p1c1A,0,nargout=0)
				if p1c2A != "":
					matlab.Output_Toggle(p1c2A,0,nargout=0)
				if p1c3A != "":
					matlab.Output_Toggle(p1c3A,0,nargout=0)
				if p1c4A != "":
					matlab.Output_Toggle(p1c4A,0,nargout=0)
			else:
				if numberChannels == 0:
					instrParamErrorMessage(self,"Please enable and set channel parameters if this supply is in use.")
					setButton.setChecked(False)
				elif numberChannels == 1:
					flag = setSupplyParams(self,self.ui.p1c1Address,self.ui.p1c1Voltage,self.ui.p1c1Current,self.ui.p1c1PartNumber,self.ui.p1c1Equip,boxDone,matlab,str(self.ui.cNumberField_p1c1.currentText()))
				elif numberChannels == 2:
					flag = setSupplyParams(self,self.ui.p1c1Address,self.ui.p1c1Voltage,self.ui.p1c1Current,self.ui.p1c1PartNumber,self.ui.p1c1Equip,boxDone,matlab,str(self.ui.cNumberField_p1c1.currentText()))
					flag = setSupplyParams(self,self.ui.p1c2Address,self.ui.p1c2Voltage,self.ui.p1c2Current,self.ui.p1c2PartNumber,self.ui.p1c2Equip,boxDone,matlab,str(self.ui.cNumberField_p1c2.currentText()))
				elif numberChannels == 3:
					flag = setSupplyParams(self,self.ui.p1c1Address,self.ui.p1c1Voltage,self.ui.p1c1Current,self.ui.p1c1PartNumber,self.ui.p1c1Equip,boxDone,matlab,str(self.ui.cNumberField_p1c1.currentText()))
					flag = setSupplyParams(self,self.ui.p1c2Address,self.ui.p1c2Voltage,self.ui.p1c2Current,self.ui.p1c2PartNumber,self.ui.p1c2Equip,boxDone,matlab,str(self.ui.cNumberField_p1c2.currentText()))
					flag = setSupplyParams(self,self.ui.p1c3Address,self.ui.p1c3Voltage,self.ui.p1c3Current,self.ui.p1c3PartNumber,self.ui.p1c3Equip,boxDone,matlab,str(self.ui.cNumberField_p1c3.currentText()))
				elif numberChannels == 4:
					flag = setSupplyParams(self,self.ui.p1c1Address,self.ui.p1c1Voltage,self.ui.p1c1Current,self.ui.p1c1PartNumber,self.ui.p1c1Equip,boxDone,matlab,str(self.ui.cNumberField_p1c1.currentText()))
					flag = setSupplyParams(self,self.ui.p1c2Address,self.ui.p1c2Voltage,self.ui.p1c2Current,self.ui.p1c2PartNumber,self.ui.p1c2Equip,boxDone,matlab,str(self.ui.cNumberField_p1c2.currentText()))
					flag = setSupplyParams(self,self.ui.p1c3Address,self.ui.p1c3Voltage,self.ui.p1c3Current,self.ui.p1c3PartNumber,self.ui.p1c3Equip,boxDone,matlab,str(self.ui.cNumberField_p1c3.currentText()))
					flag = setSupplyParams(self,self.ui.p1c4Address,self.ui.p1c4Voltage,self.ui.p1c4Current,self.ui.p1c4PartNumber,self.ui.p1c4Equip,boxDone,matlab,str(self.ui.cNumberField_p1c4.currentText()))

			if flag == 1:
				self.ui.power1Button_p1.setStyleSheet(buttonFocus)
				self.ui.p1Equip.setStyleSheet(boxDone)
				setButton.setText("Unset")
				
				if vsgType == 1 or vsgType == 4:
					if vsaType == 1 or vsaType == 2 or vsaType == 3 or vsaType == 4:
						self.ui.power1NextStack.setCurrentIndex(3)
						self.ui.saNextStack.setCurrentIndex(3)
						self.ui.meterNextStack.setCurrentIndex(5)
						self.ui.downNextStack.setCurrentIndex(6)
						self.ui.vsaNextStack.setCurrentIndex(8)
						self.ui.up_psg_next.setCurrentIndex(10)
						self.ui.vsgNextSteps.setCurrentIndex(12)
						setPrevP1Buttons(self,buttonHover,greyButton,greyButton,Qt.ArrowCursor,Qt.ArrowCursor)
					elif vsaType == 5 or vsaType ==6:
						self.ui.power1NextStack.setCurrentIndex(2)
						self.ui.saNextStack.setCurrentIndex(2)
						self.ui.meterNextStack.setCurrentIndex(4)
						self.ui.downNextStack.setCurrentIndex(5)
						self.ui.vsaNextStack.setCurrentIndex(7)
						self.ui.up_psg_next.setCurrentIndex(9)
						self.ui.vsgNextSteps.setCurrentIndex(11)
						setPrevP1Buttons(self,buttonHover,greyButton,greyHover,Qt.ArrowCursor,Qt.PointingHandCursor)
				elif vsgType == 2 or vsgType == 3:
					self.ui.power1NextStack.setCurrentIndex(1)
					self.ui.saNextStack.setCurrentIndex(1)
					self.ui.meterNextStack.setCurrentIndex(3)
					self.ui.downNextStack.setCurrentIndex(4)
					self.ui.vsaNextStack.setCurrentIndex(6)
					self.ui.up_psg_next.setCurrentIndex(8)
					self.ui.vsgNextSteps.setCurrentIndex(10)
					setPrevP1Buttons(self,buttonHover,greyHover,greyButton,Qt.PointingHandCursor,Qt.ArrowCursor)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)		
	elif setButton.isChecked() == False:
		self.ui.p1Equip.setStyleSheet(None)
		unsetPrevP1Buttons(self,greyHover)
		self.ui.power1Button_p1.setStyleSheet(buttonSelect)
		self.ui.power1NextStack.setCurrentIndex(0)
		self.ui.saNextStack.setCurrentIndex(1)
		self.ui.meterNextStack.setCurrentIndex(2)
		self.ui.downNextStack.setCurrentIndex(3)
		self.ui.vsaNextStack.setCurrentIndex(5)
		self.ui.up_psg_next.setCurrentIndex(7)
		self.ui.vsgNextSteps.setCurrentIndex(9)
		setButton.setText("Set")

def setP2(self,boxDone,buttonFocus,buttonHover,greyHover,greyButton,matlab,buttonSelect,setButton):
	checkDic = [
		self.ui.p2c1Address,
		self.ui.p2c1Voltage,
		self.ui.p2c1Current,
		self.ui.p2c2Address,
		self.ui.p2c2Voltage,
		self.ui.p2c2Current,
		self.ui.p2c3Address,
		self.ui.p2c3Voltage,
		self.ui.p2c3Current,
		self.ui.p2c4Address,
		self.ui.p2c4Voltage,
		self.ui.p2c4Current,
		self.ui.p2Enabled,
		self.ui.noChannels_p2
	]
	
	
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		
		if done:
			flag = 0;
			numberChannels = self.ui.noChannels_p2.currentIndex()
			vsaType = self.ui.vsaType.currentIndex()
			enabledSupply = self.ui.p2Enabled.currentIndex()
			p2c1A = self.ui.p2c1Address.text()
			p2c2A = self.ui.p2c2Address.text()
			p2c3A = self.ui.p2c3Address.text()
			p2c4A = self.ui.p2c3Address.text()
			
			# set instrument params
			if enabledSupply == 0 or enabledSupply == 2:
				if enabledSupply == 2:
					flag = 1;
				if enabledSupply == 0:
					instrParamErrorMessage(self,"Please fill out the current equipment's parameters before moving on.")
					setButton.setChecked(False)
				if p2c1A != "":
					matlab.Output_Toggle(p2c1A,nargout=0)
				if p2c2A != "":
					matlab.Output_Toggle(p2c2A,nargout=0)
				if p2c3A != "":
					matlab.Output_Toggle(p2c3A,nargout=0)
				if p2c4A != "":
					matlab.Output_Toggle(p2c4A,nargout=0)
			else:
				if numberChannels == 0:
					instrParamErrorMessage(self,"Please enable and set channel parameters if this supply is in use.")
					setButton.setChecked(False)
				elif numberChannels == 1:
					flag = setSupplyParams(self,self.ui.p2c1Address,self.ui.p2c1Voltage,self.ui.p2c1Current,self.ui.p2c1PartNumber,self.ui.p2c1Equip,boxDone,matlab,str(self.ui.cNumberField_p2c1.currentText()))
				elif numberChannels == 2:
					flag = setSupplyParams(self,self.ui.p2c1Address,self.ui.p2c1Voltage,self.ui.p2c1Current,self.ui.p2c1PartNumber,self.ui.p2c1Equip,boxDone,matlab,str(self.ui.cNumberField_p2c1.currentText()))
					flag = setSupplyParams(self,self.ui.p2c2Address,self.ui.p2c2Voltage,self.ui.p2c2Current,self.ui.p2c2PartNumber,self.ui.p2c2Equip,boxDone,matlab,str(self.ui.cNumberField_p2c2.currentText()))
				elif numberChannels == 3:
					flag = setSupplyParams(self,self.ui.p2c1Address,self.ui.p2c1Voltage,self.ui.p2c1Current,self.ui.p2c1PartNumber,self.ui.p2c1Equip,boxDone,matlab,str(self.ui.cNumberField_p2c1.currentText()))
					flag = setSupplyParams(self,self.ui.p2c2Address,self.ui.p2c2Voltage,self.ui.p2c2Current,self.ui.p2c2PartNumber,self.ui.p2c2Equip,boxDone,matlab,str(self.ui.cNumberField_p2c2.currentText()))
					flag = setSupplyParams(self,self.ui.p2c3Address,self.ui.p2c3Voltage,self.ui.p2c3Current,self.ui.p2c3PartNumber,self.ui.p2c3Equip,boxDone,matlab,str(self.ui.cNumberField_p2c3.currentText()))
				elif numberChannels == 4:
					flag = setSupplyParams(self,self.ui.p2c1Address,self.ui.p2c1Voltage,self.ui.p2c1Current,self.ui.p2c1PartNumber,self.ui.p2c1Equip,boxDone,matlab,str(self.ui.cNumberField_p2c1.currentText()))
					flag = setSupplyParams(self,self.ui.p2c2Address,self.ui.p2c2Voltage,self.ui.p2c2Current,self.ui.p2c2PartNumber,self.ui.p2c2Equip,boxDone,matlab,str(self.ui.cNumberField_p2c2.currentText()))
					flag = setSupplyParams(self,self.ui.p2c3Address,self.ui.p2c3Voltage,self.ui.p2c3Current,self.ui.p2c3PartNumber,self.ui.p2c3Equip,boxDone,matlab,str(self.ui.cNumberField_p2c3.currentText()))
					flag = setSupplyParams(self,self.ui.p2c4Address,self.ui.p2c4Voltage,self.ui.p2c4Current,self.ui.p2c4PartNumber,self.ui.p2c4Equip,boxDone,matlab,str(self.ui.cNumberField_p2c4.currentText()))
			
			if flag == 1:
				self.ui.power2Button_p2.setStyleSheet(buttonFocus)
				self.ui.p2Equip.setStyleSheet(boxDone)
				setButton.setText("Unset")
			
				if vsaType == 1 or vsaType == 2 or vsaType == 3 or vsaType == 4:
					self.ui.power2NextStack.setCurrentIndex(0)
					self.ui.power1NextStack.setCurrentIndex(3)
					self.ui.saNextStack.setCurrentIndex(3)
					self.ui.meterNextStack.setCurrentIndex(5)
					self.ui.downNextStack.setCurrentIndex(6)
					self.ui.vsaNextStack.setCurrentIndex(8)
					self.ui.up_psg_next.setCurrentIndex(10)
					self.ui.vsgNextSteps.setCurrentIndex(12)
					setPrevP2Buttons(self,buttonHover,greyButton)
				elif vsaType == 5 or vsaType ==6:
					self.ui.power2NextStack.setCurrentIndex(2)
					self.ui.power1NextStack.setCurrentIndex(2)
					self.ui.saNextStack.setCurrentIndex(2)
					self.ui.meterNextStack.setCurrentIndex(4)
					self.ui.downNextStack.setCurrentIndex(5)
					self.ui.vsaNextStack.setCurrentIndex(7)
					self.ui.up_psg_next.setCurrentIndex(9)
					self.ui.vsgNextSteps.setCurrentIndex(11)
					setPrevP2Buttons(self,buttonHover,greyHover)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)		
	elif setButton.isChecked() == False:
		self.ui.p2Equip.setStyleSheet(None)
		unsetPrevP2Buttons(self,greyHover)
		self.ui.power2Button_p2.setStyleSheet(buttonSelect)
		self.ui.power2NextStack.setCurrentIndex(1)
		self.ui.power1NextStack.setCurrentIndex(1)
		self.ui.saNextStack.setCurrentIndex(1)
		self.ui.meterNextStack.setCurrentIndex(3)
		self.ui.downNextStack.setCurrentIndex(4)
		self.ui.vsaNextStack.setCurrentIndex(6)
		self.ui.up_psg_next.setCurrentIndex(8)
		self.ui.vsgNextSteps.setCurrentIndex(10)
		setButton.setText("Set")
	
def setP3(self,boxDone,buttonFocus,buttonHover,matlab,buttonSelect,greyHover,setButton):
	checkDic = [
		self.ui.p3c1Address,
		self.ui.p3c1Voltage,
		self.ui.p3c1Current,
		self.ui.p3c2Address,
		self.ui.p3c2Voltage,
		self.ui.p3c2Current,
		self.ui.p3c3Address,
		self.ui.p3c3Voltage,
		self.ui.p3c3Current,
		self.ui.p3c4Address,
		self.ui.p3c4Voltage,
		self.ui.p3c4Current,
		self.ui.p3Enabled,
		self.ui.noChannels_p3
	]


	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			flag = 0;
			numberChannels = self.ui.noChannels_p3.currentIndex()
			enabledSupply = self.ui.p3Enabled.currentIndex()
			p3c1A = self.ui.p3c1Address.text()
			p3c2A = self.ui.p3c2Address.text()
			p3c3A = self.ui.p3c3Address.text()
			p3c4A = self.ui.p3c4Address.text()

			# set instrument params
			if enabledSupply == 0 or enabledSupply == 2:
				if enabledSupply == 2:
					flag = 1;
				if enabledSupply == 0:
					instrParamErrorMessage(self,"Please fill out the current equipment's parameters before moving on.")
					setButton.setChecked(False)
				if p3c1A != "":
					matlab.Output_Toggle(p3c1A,nargout=0)
				if p3c2A != "":
					matlab.Output_Toggle(p3c2A,nargout=0)
				if p3c3A != "":
					matlab.Output_Toggle(p3c3A,nargout=0)
				if p3c4A != "":
					matlab.Output_Toggle(p3c4A,nargout=0)
			else:
				if numberChannels == 0:
					instrParamErrorMessage(self,"Please enable and set channel parameters if this supply is in use.")
					setButton.setChecked(False)
				elif numberChannels == 1:
					flag = setSupplyParams(self,self.ui.p3c1Address,self.ui.p3c1Voltage,self.ui.p3c1Current,self.ui.p3c1PartNumber,self.ui.p3c1Equip,boxDone,matlab,str(self.ui.cNumberField_p3c1.currentText()))
				elif numberChannels == 2:
					flag = setSupplyParams(self,self.ui.p3c1Address,self.ui.p3c1Voltage,self.ui.p3c1Current,self.ui.p3c1PartNumber,self.ui.p3c1Equip,boxDone,matlab,str(self.ui.cNumberField_p3c1.currentText()))
					flag = setSupplyParams(self,self.ui.p3c2Address,self.ui.p3c2Voltage,self.ui.p3c2Current,self.ui.p3c2PartNumber,self.ui.p3c2Equip,boxDone,matlab,str(self.ui.cNumberField_p3c2.currentText()))
				elif numberChannels == 3:
					flag = setSupplyParams(self,self.ui.p3c1Address,self.ui.p3c1Voltage,self.ui.p3c1Current,self.ui.p3c1PartNumber,self.ui.p3c1Equip,boxDone,matlab,str(self.ui.cNumberField_p3c1.currentText()))
					flag = setSupplyParams(self,self.ui.p3c2Address,self.ui.p3c2Voltage,self.ui.p3c2Current,self.ui.p3c2PartNumber,self.ui.p3c2Equip,boxDone,matlab,str(self.ui.cNumberField_p3c2.currentText()))
					flag = setSupplyParams(self,self.ui.p3c3Address,self.ui.p3c3Voltage,self.ui.p3c3Current,self.ui.p3c3PartNumber,self.ui.p3c3Equip,boxDone,matlab,str(self.ui.cNumberField_p3c3.currentText()))
				elif numberChannels == 4:
					flag = setSupplyParams(self,self.ui.p3c1Address,self.ui.p3c1Voltage,self.ui.p3c1Current,self.ui.p3c1PartNumber,self.ui.p3c1Equip,boxDone,matlab,str(self.ui.cNumberField_p3c1.currentText()))
					flag = setSupplyParams(self,self.ui.p3c2Address,self.ui.p3c2Voltage,self.ui.p3c2Current,self.ui.p3c2PartNumber,self.ui.p3c2Equip,boxDone,matlab,str(self.ui.cNumberField_p3c2.currentText()))
					flag = setSupplyParams(self,self.ui.p3c3Address,self.ui.p3c3Voltage,self.ui.p3c3Current,self.ui.p3c3PartNumber,self.ui.p3c3Equip,boxDone,matlab,str(self.ui.cNumberField_p3c3.currentText()))
					flag = setSupplyParams(self,self.ui.p3c4Address,self.ui.p3c4Voltage,self.ui.p3c4Current,self.ui.p3c4PartNumber,self.ui.p3c4Equip,boxDone,matlab,str(self.ui.cNumberField_p3c4.currentText()))
			
			if flag == 1:
				self.ui.p3Equip.setStyleSheet(boxDone)
				setButton.setText("Unset")
			
				self.ui.power3Button_p3.setStyleSheet(buttonFocus)
				self.ui.power3Button_p3_2.setStyleSheet(buttonFocus)
				self.ui.power3NextStack.setCurrentIndex(1)
				self.ui.power2NextStack.setCurrentIndex(0)
				self.ui.power1NextStack.setCurrentIndex(3)
				self.ui.saNextStack.setCurrentIndex(3)
				self.ui.meterNextStack.setCurrentIndex(5)
				self.ui.downNextStack.setCurrentIndex(6)
				self.ui.vsaNextStack.setCurrentIndex(8)
				self.ui.up_psg_next.setCurrentIndex(10)
				self.ui.vsgNextSteps.setCurrentIndex(12)
				setPrevP3Buttons(self,buttonHover)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)		
	elif setButton.isChecked() == False:
		self.ui.p3Equip.setStyleSheet(None)
		unsetPrevP3Buttons(self,greyHover)
		self.ui.power3Button_p3.setStyleSheet(buttonSelect)
		self.ui.power3Button_p3_2.setStyleSheet(buttonSelect)
		self.ui.power3NextStack.setCurrentIndex(0)
		self.ui.power2NextStack.setCurrentIndex(2)
		self.ui.power1NextStack.setCurrentIndex(2)
		self.ui.saNextStack.setCurrentIndex(2)
		self.ui.meterNextStack.setCurrentIndex(4)
		self.ui.downNextStack.setCurrentIndex(5)
		self.ui.vsaNextStack.setCurrentIndex(7)
		self.ui.up_psg_next.setCurrentIndex(9)
		self.ui.vsgNextSteps.setCurrentIndex(11)
		setButton.setText("Set")
			
def setVSAMeasDig(self,boxDone,buttonHover,buttonDone,setButton,matlab):
	checkDic=[
		self.ui.centerFreq_vsaMeas,
		self.ui.sampRate_vsaMeas,
		self.ui.vsgFrameTime_vsaMeas_2,
		self.ui.frameTime_vsaMeas_2
		]
	vsaType = self.ui.vsaWorkflow_vsaMeas.currentIndex()
	vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			self.ui.vsaMeasGenEquip.setStyleSheet(boxDone)
			self.ui.vsaMeasGenEquip_2.setStyleSheet(boxDone)
			self.ui.vsaMeasDigEquip.setStyleSheet(boxDone)
			self.ui.digMark_vsaMeas.setVisible(True)
			self.ui.digMark_vsaMeas_2.setVisible(True)
			# if no downconverter (no prompt to sa, only advanced setting)
			if vsaType == 0:
				if vsgType == 3: # vsg
					self.ui.vsaMeasNextStack.setCurrentIndex(6)
					setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonHover)
				else:
					self.ui.vsaMeasNextStack.setCurrentIndex(5)
					setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonHover)
					setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonHover)
					setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonHover)
			elif vsaType == 1: # has down
				self.ui.vsaMeasNextStack.setCurrentIndex(1)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)	
	elif setButton.isChecked() == False:
		self.ui.vsaMeasNextStack.setCurrentIndex(0)
		self.ui.vsaMeasGenEquip.setStyleSheet(None)
		self.ui.vsaMeasGenEquip_2.setStyleSheet(None)
		self.ui.vsaMeasDigEquip.setStyleSheet(None)
		self.ui.digMark_vsaMeas.setVisible(False)
		self.ui.digMark_vsaMeas_2.setVisible(False)
		setColourAndCursor(self,self.ui.awgButton_vsaMeas,buttonDone,Qt.ArrowCursor)
		setColourAndCursor(self,self.ui.awgButton_vsaMeas_2,buttonDone,Qt.ArrowCursor)
		setColourAndCursor(self,self.ui.awgButton_vsaMeas_3,buttonDone,Qt.ArrowCursor)
		setColourAndCursor(self,self.ui.vsgButton_vsaMeas,buttonDone,Qt.ArrowCursor)
		setButton.setText("Set")
		
def setVSAMeasGen(self,boxDone,buttonHover,buttonDone,setButton,matlab):
	checkDic=[
			self.ui.centerFreq_vsaMeas_2,
			self.ui.sampRate_vsaMeas_2,
			self.ui.vsgFrameTime_vsaMeas_2,
			self.ui.frameTime_vsaMeas_2
		]
	
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			vsaType = self.ui.vsaWorkflow_vsaMeas.currentIndex()
			vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
			downType = self.ui.single_down_vsaMeas_stack.currentIndex()
			analyzerType = self.ui.single_vsaMeas_stack.currentIndex()
			self.ui.vsaMeasGenEquip.setStyleSheet(boxDone)
			self.ui.vsaMeasGenEquip_2.setStyleSheet(boxDone)
			if vsaType == 1:
				if downType == 1: # scope
					self.ui.scopeMark_vsaMeas.setVisible(True)
					self.ui.scopeMark_vsaMeas_2.setVisible(True)
					self.ui.scopeMark_vsaMeas_3.setVisible(True)
					self.ui.scopeMark_vsaMeas_4.setVisible(True)
					self.ui.vsaMeasNextStack.setCurrentIndex(1)
				elif downType == 0: # dig
					self.ui.digMark_vsaMeas.setVisible(True)
					self.ui.digMark_vsaMeas_2.setVisible(True)
					self.ui.digMark_vsaMeas_3.setVisible(True)
					self.ui.digMark_vsaMeas_4.setVisible(True)
					self.ui.vsaMeasNextStack.setCurrentIndex(1)
			elif vsaType == 0:
				if analyzerType == 0: # scope
					self.ui.scopeMark_vsaMeas.setVisible(True)
					self.ui.scopeMark_vsaMeas_2.setVisible(True)
					self.ui.scopeMark_vsaMeas_3.setVisible(True)
					self.ui.scopeMark_vsaMeas_4.setVisible(True)
				elif analyzerType == 1: # dig
					self.ui.digMark_vsaMeas.setVisible(True)
					self.ui.digMark_vsaMeas_2.setVisible(True)
					self.ui.digMark_vsaMeas_3.setVisible(True)
					self.ui.digMark_vsaMeas_4.setVisible(True)
				elif analyzerType == 2: # uxa
					self.ui.uxaMark_vsaMeas.setVisible(True)
					self.ui.uxaMark_vsaMeas_2.setVisible(True)
				elif analyzerType == 3: # pxa
					self.ui.pxaMark_vsaMeas.setVisible(True)
					self.ui.pxaMark_vsaMeas_2.setVisible(True)
				if vsgType == 3: # vsg
					self.ui.vsaMeasNextStack.setCurrentIndex(6)
					setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonHover)
				else:
					self.ui.vsaMeasNextStack.setCurrentIndex(5)
					setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonHover)
					setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonHover)
					setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonHover)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)	
	elif setButton.isChecked() == False:
		self.ui.vsaMeasGenEquip.setStyleSheet(None)
		self.ui.vsaMeasGenEquip_2.setStyleSheet(None)
		self.ui.vsaMeasNextStack.setCurrentIndex(0)
		self.ui.digMark_vsaMeas.setVisible(False)
		self.ui.digMark_vsaMeas_2.setVisible(False)
		self.ui.digMark_vsaMeas_3.setVisible(False)
		self.ui.digMark_vsaMeas_4.setVisible(False)
		self.ui.scopeMark_vsaMeas.setVisible(False)
		self.ui.scopeMark_vsaMeas_2.setVisible(False)
		self.ui.scopeMark_vsaMeas_3.setVisible(False)
		self.ui.scopeMark_vsaMeas_4.setVisible(False)
		self.ui.uxaMark_vsaMeas.setVisible(False)
		self.ui.uxaMark_vsaMeas_2.setVisible(False)
		self.ui.pxaMark_vsaMeas.setVisible(False)
		self.ui.pxaMark_vsaMeas_2.setVisible(False)
		setColourAndCursor(self,self.ui.awgButton_vsaMeas,buttonDone,Qt.ArrowCursor)
		setColourAndCursor(self,self.ui.awgButton_vsaMeas_2,buttonDone,Qt.ArrowCursor)
		setColourAndCursor(self,self.ui.awgButton_vsaMeas_3,buttonDone,Qt.ArrowCursor)
		setColourAndCursor(self,self.ui.vsgButton_vsaMeas,buttonDone,Qt.ArrowCursor)
		setButton.setText("Set")

def setVSAMeasAdv(self,boxDone,setButton):
	
	checkDic =[
		self.ui.lineEdit_285
	]


	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")

			self.ui.vsaMeasAdvEquip.setStyleSheet(boxDone)
			self.ui.saMark_vsaMeas.setVisible(True)
			self.ui.saMark_vsaMeas_2.setVisible(True)
			self.ui.saMark_vsaMeas_3.setVisible(True)
			self.ui.saMark_vsaMeas_4.setVisible(True)
			self.ui.saMark_vsgMeas.setVisible(True)
			self.ui.saMark_vsgMeas_2.setVisible(True)
			self.ui.saMark_vsgMeas_3.setVisible(True)
			self.ui.saMark_vsgMeas_4.setVisible(True)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)	
	elif  setButton.isChecked() == False:
		self.ui.vsaMeasAdvEquip.setStyleSheet(None)
		setButton.setText("Set")
	
def rxCalRoutine(self,boxDone,buttonHover,setButton,matlab):
	checkDic = [
		#comb
		self.ui.rfSpacingField_comb,
		self.ui.ifSpacingField_comb,
		self.ui.refFileField_comb,
		self.ui.rfCenterFreqField_comb,
		self.ui.rfCalStartFreqField_comb,
		self.ui.rfCalStopFreqField_comb,
		self.ui.loFreqOffsetField_comb,
		self.ui.vsaCalSaveLocField_comb,
		self.ui.subrateField_comb,
		self.ui.freqResField_comb,
		self.ui.despurFlagField_comb,
		self.ui.spurStartField_comb,
		self.ui.spurSpacingField_comb,
		self.ui.spurEndField_comb,
		self.ui.smoothFlagField_comb,
		self.ui.smoothOrderField_comb,
		#other
		self.ui.rfCenterFreq_down,
		self.ui.ifCenterFreq_down,
		self.ui.noFrameTimes_down,
		self.ui.loFreq_down,
		self.ui.mirrorFlag_down,
		self.ui.trigAmp_down
	]

	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			
			# determine whcih fields to use
			
			addressField = ""
			fCarrierField = ""
			fSampleField = ""
			
			vsaPage = self.ui.vsaMeasGenStack.currentIndex()
			if vsaPage == 1:
				fCarrierField = self.ui.centerFreq_vsaMeas.text()
				fSampleField = self.ui.sampRate_vsaMeas.text()
			elif vsaPage == 0:
				fCarrierField = self.ui.centerFreq_vsaMeas_2.text()
				fSampleField = self.ui.sampRate_vsaMeas_2.text()
			vsaType = self.ui.vsaType.currentIndex()
			if vsaType == 1 or vsaType == 5:
				addressField = self.ui.address_scope.text()
			elif vsaType == 2 or vsaType == 6:
				addressField = self.ui.address_dig.text()
			elif vsaType == 3 or vsaType == 4:
				addressField = self.ui.address_sa.text()
			channelVec = [0,0,0,0]
			c1 = self.ui.measChannel1.isChecked()
			c2 = self.ui.measChannel2.isChecked()
			c3 = self.ui.measChannel3.isChecked()
			c4 = self.ui.measChannel4.isChecked()
			if c1:
				channelVec[0] = 1
			elif c1 == False:
				channelVec[0] = 0
			if c2:
				channelVec[1] = 1
			elif c2 == False:
				channelVec[1] = 0
			if c3:
				channelVec[2] = 1
			elif c3 == False:
				channelVec[2] = 0
			if c4:
				channelVec[3] = 1
			elif c4 == False:
				channelVec[3] = 0
				
			# define dictionaries
			cal = {
				"RFToneSpacing" : self.ui.rfSpacingField_comb.text(),
				"IFToneSpacing" : self.ui.ifSpacingField_comb.text(),
				"CombReferenceFile" : self.ui.refFileField_comb.text(),
				"RFCenterFrequency" :self.ui.rfCenterFreqField_comb.text(),
				"RFCalibrationStartFrequency" : self.ui.rfCalStartFreqField_comb.text(),
				"RFCalibrationStopFrequency" : self.ui.rfCalStopFreqField_comb.text(),
				"LOFrequencyOffset" : self.ui.loFreqOffsetField_comb.text(),
				"SaveLocation" : self.ui.vsaCalSaveLocField_comb.text(),
				"SubRateFlag" : self.ui.subrateField_comb.currentIndex(),
				"FreqRes" : self.ui.freqResField_comb.text(),
				"DespurFlag" : self.ui.despurFlagField_comb.currentIndex(),
				"ScopeSpurStart" : self.ui.spurStartField_comb.text(),
				"ScopeSpurSpacing" : self.ui.spurSpacingField_comb.text(),
				"ScopeSpurEnd" : self.ui.spurEndField_comb.text(),
				"MovingAverageFlag" : self.ui.smoothFlagField_comb.currentIndex(),
				"MovingAverageOrder" : self.ui.smoothOrderField_comb.text(),
			}
			rx = {
				"Type" : self.ui.vsaType.currentIndex(),
				"Fcarrier" : fCarrierField,
				"mirrorFlag" : self.ui.mirrorFlag_down.currentIndex(),
				"Fsample" : fSampleField,
				"NumberOfMeasuredPeriods" : self.ui.noFrameTimes_down.text(),
				"VisaAddress": addressField,
				"DriverPath" : self.ui.driverPath_scope.text(),
				"EnableExternalClock_Scope" : self.ui.extClkEnabled_scope.currentIndex(),
				"TriggerChannel" : self.ui.trigChannel_scope.text(),
				"ChannelVec": channelVec,
				"EnableExternalClock_Dig" : self.ui.clockEnabled_dig.currentIndex(),
				"ExternalClockFrequency" : self.ui.clockFreq_dig.currentIndex(),
				"ACDCCoupling" : self.ui.coupling_dig.currentIndex(),
				"VFS" : self.ui.vfs_dig.text(),
				"Interleaving" : self.ui.interleaving_dig.currentIndex(),
				"AnalysisBandwidth":self.ui.analysisBandwidth_sa.text(),
				"Attenuation":self.ui.attenuation_sa.text(),
				"TriggerLevel":self.ui.trigLevel_sa.text(),
				"ClockReference" : self.ui.clockRef_sa.currentIndex(),
			}
			tx = {
				"Type": self.ui.vsgSetup.currentIndex(),
				"Model": self.ui.partNum_awg.text(),
				"Fsample" : self.ui.maxSampleRate_awg.text(),
				"ReferenceClockSource": self.ui.refClockSorce_awg.currentIndex(),
				"ReferenceClock": self.ui.extRefFreq_awg.text(),
				"VFS": self.ui.dacRange_awg.text(),	
				"TriggerAmplitude": self.ui.trigAmp_down.text()
			}
			downDict = {
				"rfCenterFreq" : self.ui.rfCenterFreq_down.text(),
				"ifCenterFreq" : self.ui.ifCenterFreq_down.text(),
				"loFreq" : self.ui.loFreq_down.text(),
			}
			
			# set matlab parameters
			matlab.Set_VSA_Calibration(cal,rx,tx,nargout=0)
			matlab.Set_Down_Calibration(downDict,nargout=0)
			
			vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
			if vsgType == 3: # vsg
				self.ui.vsaMeasNextStack.setCurrentIndex(6)
				setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonHover)
			else:
				self.ui.vsaMeasNextStack.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonHover)
			self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.downEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.rxEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.trigEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.vsaResultsStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaResultsStack_vsgMeas.setCurrentIndex(0)
			self.ui.vsaCalResultsStack_algo.setCurrentIndex(0)
			self.ui.debugVSAStack.setCurrentIndex(0)
			self.ui.downMark_vsaMeas.setVisible(True)
			self.ui.downMark_vsaMeas_2.setVisible(True)
			self.ui.downMark_vsgMeas.setVisible(True)
			self.ui.downMark_vsgMeas_2.setVisible(True)
			self.progressBar = QProgressBar()
			self.progressBar.setRange(1,10);
			self.progressBar.setTextVisible(True);
			self.progressBar.setFormat("Currently Running: RX Calibration Routine")
			self.ui.statusBar.addWidget(self.progressBar,1)
			completed = 0
			while completed < 100:
				completed = completed + 0.00001
				self.progressBar.setValue(completed)
			self.ui.statusBar.removeWidget(self.progressBar)
			# to show progress bar, need both addWidget() and show()
			self.ui.statusBar.showMessage("RX Calibration Routine Complete",3000)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)		
	elif setButton.isChecked() == False:
		self.ui.combEquip_vsaMeas.setStyleSheet(None)
		self.ui.downEquip_vsaMeas.setStyleSheet(None)
		self.ui.rxEquip_vsaMeas.setStyleSheet(None)
		self.ui.trigEquip_vsaMeas.setStyleSheet(None)
		self.ui.downMark_vsaMeas.setVisible(False)
		self.ui.downMark_vsaMeas_2.setVisible(False)
		self.ui.downMark_vsgMeas.setVisible(False)
		self.ui.downMark_vsgMeas_2.setVisible(False)
		self.ui.debugVSAStack.setCurrentIndex(1)
		self.ui.vsaMeasNextStack.setCurrentIndex(4)
		setButton.setText("Set && Run")
		
def noRXCalRoutine(self,boxDone,buttonHover,setButton,matlab):
	checkDic = [
		self.ui.rfCenterFreq_down,
		self.ui.ifCenterFreq_down,
		self.ui.loFreq_down,
		self.ui.vsaCalFileField_comb
	]
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			# set matlab parameters
			downDict = {
				"rfCenterFreq" : self.ui.rfCenterFreq_down.text(),
				"ifCenterFreq" : self.ui.ifCenterFreq_down.text(),
				"loFreq" : self.ui.loFreq_down.text(),
			}
			matlab.Set_Down_Calibration(downDict,nargout=0)
			setButton.setText("Unset")

			vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
			self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.downEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.rxEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.trigEquip_vsaMeas.setStyleSheet(boxDone)
			self.ui.vsaResultsStack_vsaMeas.setCurrentIndex(0)
			self.ui.vsaResultsStack_vsgMeas.setCurrentIndex(0)
			self.ui.vsaCalResultsStack_algo.setCurrentIndex(0)
			self.ui.downMark_vsaMeas.setVisible(True)
			self.ui.downMark_vsaMeas_2.setVisible(True)
			self.ui.downMark_vsgMeas.setVisible(True)
			self.ui.downMark_vsgMeas_2.setVisible(True)
			if vsgType == 3: # vsg
				self.ui.vsaMeasNextStack.setCurrentIndex(6)
				setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonHover)
			else:
				self.ui.vsaMeasNextStack.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonHover)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)			
	elif setButton.isChecked() == False:
		self.ui.combEquip_vsaMeas.setStyleSheet(None)
		self.ui.downEquip_vsaMeas.setStyleSheet(None)
		self.ui.rxEquip_vsaMeas.setStyleSheet(None)
		self.ui.trigEquip_vsaMeas.setStyleSheet(None)
		self.ui.downMark_vsaMeas.setVisible(False)
		self.ui.downMark_vsaMeas_2.setVisible(False)
		self.ui.downMark_vsgMeas.setVisible(False)
		self.ui.downMark_vsgMeas_2.setVisible(False)
		self.ui.vsaMeasNextStack.setCurrentIndex(3)
		setButton.setText("Set")
		
def awgCalRoutine(self,boxDone,setButton,matlab):
	checkDic = [
		self.ui.noIterations_awgCal,
		self.ui.toneSpacing_awgCal,
		self.ui.startFreq_awgCal,
		self.ui.endFreq_awgCal,
		self.ui.realBasisFlag_awgCal,
		self.ui.phaseDistr_awgCal,
		self.ui.paprMin_awg,
		self.ui.paprMax_awg,
		self.ui.freqRes_awgCal,
		self.ui.awgCalSaveLocField_vsgMeas,
		
		self.ui.centerFreq_awgCal,
		self.ui.ampCorrection_awgCal,
		self.ui.vfs_awgCal,
		self.ui.trigAmp_awgCal,
		self.ui.sampleClockFreq_awgCal,
		
		self.ui.mirrorFlag_awgCal,
		self.ui.noRXPeriods_awgCal,
		self.ui.downFilterFileField_vsgMeas,
		self.ui.noTXPeriods_awgCal,
		self.ui.awgChannel_awgCal,
		self.ui.useVSACal_awgCal,
		self.ui.vsaCalFileField_vsgMeas
	]
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			fCarrierField = ""
			fSampleField = ""
			addressField = ""
			
			# determine which field on which page should be used
			vsaPage = self.ui.vsaMeasGenStack.currentIndex()
			if vsaPage == 1:
				fCarrierField = self.ui.centerFreq_vsaMeas.text()
				fSampleField = self.ui.sampRate_vsaMeas.text()
			elif vsaPage == 0:
				fCarrierField = self.ui.centerFreq_vsaMeas_2.text()
				fSampleField = self.ui.sampRate_vsaMeas_2.text()
			vsaType = self.ui.vsaType.currentIndex()
			if vsaType == 1 or vsaType == 5:
				addressField = self.ui.address_scope.text()
			elif vsaType == 2 or vsaType == 6:
				addressField = self.ui.address_dig.text()
			elif vsaType == 3 or vsaType == 4:
				addressField = self.ui.address_sa.text()
			channelVec = [0,0,0,0]
			c1 = self.ui.measChannel1.isChecked()
			c2 = self.ui.measChannel2.isChecked()
			c3 = self.ui.measChannel3.isChecked()
			c4 = self.ui.measChannel4.isChecked()
			if c1:
				channelVec[0] = 1
			elif c1 == False:
				channelVec[0] = 0
			if c2:
				channelVec[1] = 1
			elif c2 == False:
				channelVec[1] = 0
			if c3:
				channelVec[2] = 1
			elif c3 == False:
				channelVec[2] = 0
			if c4:
				channelVec[3] = 1
			elif c4 == False:
				channelVec[3] = 0
			
			#define dictionaries
			cal = {
				"NumIterations" : self.ui.noIterations_awgCal.text(),
				"ToneSpacing" : self.ui.toneSpacing_awgCal.text(),
				"StartingToneFreq" : self.ui.startFreq_awgCal.text(),
				"EndingToneFreq" : self.ui.endFreq_awgCal.text(),
				"RealBasisFlag" : self.ui.realBasisFlag_awgCal.text(),
				"PhaseDistr" : self.ui.phaseDistr_awgCal.text(),
				"Fres" : self.ui.freqRes_awgCal.text(),
				"SaveLocation" : self.ui.awgCalSaveLocField_vsgMeas.text(),
				"PAPRmin" : self.ui.paprMin_awg.text(),
				"PAPRmax" : self.ui.paprMax_awg.text(),
				"vsaCalFlag" : self.ui.useVSACal_awgCal.currentIndex(),
				"vsaCalFile" : self.ui.vsaCalFileField_vsgMeas.text()
			}
			tx = {
				"Type": self.ui.vsgSetup.currentIndex(),
				"Model": self.ui.partNum_awg.text(),
				"Fsample" : self.ui.maxSampleRate_awg.text(),
				"ReferenceClockSource": self.ui.refClockSorce_awg.currentIndex(),
				"ReferenceClock" : self.ui.sampleClockFreq_awgCal.text(),
				"VFS" : self.ui.vfs_awgCal.text(),
				"TriggerAmplitude" : self.ui.trigAmp_awgCal.text(),
				"Fcarrier" : self.ui.centerFreq_awgCal.text(),
				"NumberOfTransmittedPeriods" : self.ui.noTXPeriods_awgCal.text(),
				"AWG_Channel" : self.ui.awgChannel_awgCal.text(),
			}
			rx = {
				"Type" : self.ui.vsaType.currentIndex(),
				"Fcarrier" : fCarrierField,
				"MirrorFlag" : self.ui.mirrorFlag_awgCal.currentIndex(),
				"Fsample" : fSampleField,
				"NumberOfMeasuredPeriods" : self.ui.noRXPeriods_awgCal.text(),
				"VisaAddress": addressField,
				"DriverPath": self.ui.driverPath_scope.text(),
				"EnableExternalClock_Scope": self.ui.extClkEnabled_scope.currentIndex(),
				"ChannelVec": channelVec,
				"EnableExternalClock_Dig" : self.ui.clockEnabled_dig.currentIndex(),
				"ExternalClockFrequency" : self.ui.clockFreq_dig.currentIndex(),
				"ACDCCoupling" : self.ui.coupling_dig.currentIndex(),
				"VFS" : self.ui.vfs_dig.text(),
				"Interleaving" : self.ui.interleaving_dig.currentIndex(),
				"AnalysisBandwidth" : self.ui.analysisBandwidth_sa.text(),
				"Attenuation" : self.ui.attenuation_sa.text(),
				"ClockReference" : self.ui.clockRef_sa.currentIndex(),
				"TriggerLevel": self.ui.trigLevel_sa.text(),
				"FilterFile" : self.ui.downFilterFileField_vsgMeas.text(),
			}
			# set matlab parameters
			matlab.Set_AWG_Calibration(cal,tx,rx,nargout=0)

			setButton.setText("Unset")
			
			self.ui.awgEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.rxEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.vsgEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.calEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.awgCalEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.vsgMeasNextStack.setCurrentIndex(5)
			self.ui.debugVSGStack.setCurrentIndex(0)
			self.ui.vsgResultsFileStack_vsgMeas.setCurrentIndex(1)
			self.ui.vsgCalPaths_algo.setCurrentIndex(1)
			self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
			self.ui.awgMark_vsgMeas.setVisible(True)
			self.ui.awgMark_vsgMeas_2.setVisible(True)
			self.ui.awgMark_vsgMeas_3.setVisible(True)
			
			self.progressBar = QProgressBar()
			self.progressBar.setRange(1,10);
			self.progressBar.setTextVisible(True);
			self.progressBar.setFormat("Currently Running: AWG Calibration Routine")
			self.ui.statusBar.addWidget(self.progressBar,1)
			completed = 0
			while completed < 100:
				completed = completed + 0.00001
				self.progressBar.setValue(completed)
			self.ui.statusBar.removeWidget(self.progressBar)
			# to show progress bar, need both addWidget() and show()
			self.ui.statusBar.showMessage("AWG Calibration Routine Complete",3000)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)			
	elif setButton.isChecked() == False:
		setButton.setText("Set && Run")
		self.ui.awgEquip_vsgMeas.setStyleSheet(None)
		self.ui.rxEquip_vsgMeas.setStyleSheet(None)
		self.ui.vsgEquip_vsgMeas.setStyleSheet(None)
		self.ui.calEquip_vsgMeas.setStyleSheet(None)
		self.ui.awgMark_vsgMeas.setVisible(False)
		self.ui.awgMark_vsgMeas_2.setVisible(False)
		self.ui.awgMark_vsgMeas_3.setVisible(False)
		self.ui.vsgMeasNextStack.setCurrentIndex(3)
		self.ui.debugVSGStack.setCurrentIndex(2)
		
def noAWGCalRoutine(self,boxDone,setButton,matlab):
	checkDic = [
		self.ui.centerFreq_awgCal_2,
		self.ui.ampCorrection_awgCal_2,
		self.ui.vfs_awgCal_2,
		self.ui.trigAmp_awgCal_2,
		self.ui.sampleClockFreq_awgCal_2,
		self.ui.awgCalFileField_vsgMeas_2,
		self.ui.noIterations_awgCal_2,
		self.ui.toneSpacing_awgCal_2,
		self.ui.startFreq_awgCal_2,
		self.ui.endFreq_awgCal_2,
		self.ui.realBasisFlag_awgCal_2,
		self.ui.phaseDistr_awgCal_2,
		self.ui.freqRes_awgCal_2,
		self.ui.awgCalSaveLocField_vsgMeas_2

	]
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			self.ui.awgEquip_vsgMeas_2.setStyleSheet(boxDone)
			self.ui.awgCalEquip_vsgMeas_2.setStyleSheet(boxDone)
			self.ui.vsgMeasNextStack.setCurrentIndex(5)
			self.ui.awgMark_vsgMeas.setVisible(True)
			self.ui.awgMark_vsgMeas_2.setVisible(True)
			self.ui.awgMark_vsgMeas_3.setVisible(True)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
	elif setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.awgEquip_vsgMeas_2.setStyleSheet(None)
		self.ui.awgCalEquip_vsgMeas_2.setStyleSheet(None)
		self.ui.awgMark_vsgMeas.setVisible(False)
		self.ui.awgMark_vsgMeas_2.setVisible(False)
		self.ui.awgMark_vsgMeas_3.setVisible(False)
		self.ui.vsgMeasNextStack.setCurrentIndex(4)
		self.ui.debugVSGStack.setCurrentIndex(2)
		
		
def setAdvAWGVSA_vsgMeas(self,boxDone,setButton):
	checkDic = [
		self.ui.lineEdit_86,
		self.ui.xCorrLength_vsgMeas
	]
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			self.ui.setAdv_vsgMeas.setText("Unset")
			self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(boxDone)
			self.ui.awgAdvEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.vsaAdvEquip_vsgMeas.setStyleSheet(boxDone)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
	elif setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.setAdv_vsgMeas.setText("Set")
		self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(None)
		self.ui.awgAdvEquip_vsgMeas.setStyleSheet(None)
		self.ui.vsaAdvEquip_vsgMeas.setStyleSheet(None)	
			
def setAdvAWG_vsgMeas(self,boxDone,setButton):

	checkDic = [self.ui.lineEdit_85]
	
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(boxDone)
			self.ui.awgAdvEquip_vsgMeas.setStyleSheet(boxDone)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
	elif setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(None)
		self.ui.awgAdvEquip_vsgMeas.setStyleSheet(None)
			
def awgPreview(self):
	self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
	self.ui.resultsTabs_vsgMeas.setCurrentIndex(1)
	
def setUpVSGMeas(self,boxDone,setButton):
	checkDic = [
		self.ui.centerFreq_awgCal,
		self.ui.ampCorrection_awgCal,
		self.ui.ampCorrFile_vsgMeas,
		self.ui.vfs_awgCal,
		self.ui.trigAmp_awgCal,
		self.ui.noTXPeriods_awgCal,
		self.ui.awgChannel_awgCal,
		self.ui.sampleClockFreq_awgCal,
		self.ui.mirrorFlag_awgCal,
		self.ui.noRXPeriods_awgCal,
		self.ui.downFilterFileField_vsgMeas,
		self.ui.noIterations_awgCal,
		self.ui.toneSpacing_awgCal.
		self.ui.startFreq_awgCal,
		self.ui.endFreq_awgCal,
		self.ui.realBasisFlag_awgCal,
		self.ui.phaseDistr_awgCal,
		self.ui.paprMin_awg,
		self.ui.paprMax_awg,
		self.ui.freqRes_awgCal,
		self.ui.awgCalSaveLocField_vsgMeas,
		self.ui.awgCalFileField_vsgMeas,
		self.ui.useVSACal_awgCal,
		self.ui.vsaCalFileField_vsgMeas
	]
	
	
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")

			awgChecked = self.ui.awgSet_vsgMeas.isChecked()
			awgRunChecked = self.ui.awgSetRun_vsgMeas.isChecked()
			if awgChecked or awgRunChecked:
				self.ui.upCalHomoEquip_vsgMeas.setStyleSheet(boxDone)
				self.ui.upCalHeteroEquip_vsgMeas.setStyleSheet(boxDone)
				self.ui.upEquip_vsgMeas.setStyleSheet(boxDone)
				self.ui.vsgMeasNextStack.setCurrentIndex(8)
				self.ui.upMark_vsgMeas.setVisible(True)
				self.ui.psgMark_vsgMeas.setVisible(True)
			else:
				instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
				setButton.setChecked(False)
	elif setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.upCalHomoEquip_vsgMeas.setStyleSheet(None)
		self.ui.upCalHeteroEquip_vsgMeas.setStyleSheet(None)
		self.ui.upEquip_vsgMeas.setStyleSheet(None)
		self.ui.upMark_vsgMeas.setVisible(False)
		self.ui.psgMark_vsgMeas.setVisible(False)
		self.ui.vsgMeasNextStack.setCurrentIndex(7)
		
def setHetero(self,boxDone,setButton,matlab):
	checkDic = [
		self.ui.comboBox_103,
		self.ui.lineEdit_155,
		self.ui.lineEdit_156,
		self.ui.lineEdit_157,
		self.ui.lineEdit_158,
		self.ui.lineEdit_159,
		self.ui.lineEdit_161,
		self.ui.lineEdit_162,
		self.ui.lineEdit_163,
		self.ui.lineEdit_160,
		self.ui.lineEdit_164,
		self.ui.lineEdit_165,
		self.ui.lineEdit_166,
		self.ui.lineEdit_167,
		self.ui.comboBox_102,
		self.ui.mirrorFlag_hetero,
		self.ui.freqDomainAlign_hetero,
		self.ui.noRXPeriods_hetero,
		self.ui.downFileField_vsgMeas,
		self.ui.noTXPeriods_hetero,
		self.ui.vsgCenterFreq_hetero,
		self.ui.expansionMarginEnable_hetero,
		self.ui.expansionMargin_hetero,
		self.ui.vsaCalFileEnable_hetero,
		self.ui.vsaCalFileField_vsgMeas_2,
		self.ui.upCalFileField_vsgMeas_2,
		self.ui.toneSpacing_hetero,
		self.ui.startTone_hetero,
		self.ui.endTone_hetero,
		self.ui.realBasisFlag_hetero,
		self.ui.phaseDistribution_hetero,
		self.ui.paprMin_heter,
		self.ui.paprMax_hetero,
		self.ui.freqResolution_hetero,
		self.ui.noIterations_hetero,			
		self.ui.upCalSaveLocField_vsgMeas
	
		
		
	]
	


	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			
			addressField = ""
			vfsField = ""
			trigAmpField = ""
			fCarrierField = ""
			fSampleField = ""
			
			# determine which field on which page should be used
			awgCalPage = self.ui.awgParamsStack_vsgMeas.currentIndex()
			if awgCalPage == 2:
				vfsField = self.ui.vfs_awgCal_2.text()
				trigAmpField = self.ui.trigAmp_awgCal_2.text()
			elif awgCalPage == 1:
				vfsField = self.ui.vfs_awgCal.text()
				trigAmpField = self.ui.trigAmp_awgCal.text()
			vsaPage = self.ui.vsaMeasGenStack.currentIndex()
			if vsaPage == 1:
				fCarrierField = self.ui.centerFreq_vsaMeas.text()
				fSampleField = self.ui.sampRate_vsaMeas.text()
			elif vsaPage == 0:
				fCarrierField = self.ui.centerFreq_vsaMeas_2.text()
				fSampleField = self.ui.sampRate_vsaMeas_2.text()
			vsaType = self.ui.vsaType.currentIndex()
			if vsaType == 1 or vsaType == 5:
				addressField = self.ui.address_scope.text()
			elif vsaType == 2 or vsaType == 6:
				addressField = self.ui.address_dig.text()
			elif vsaType == 3 or vsaType == 4:
				addressField = self.ui.address_sa.text()
			channelVec = [0,0,0,0]
			c1 = self.ui.measChannel1.isChecked()
			c2 = self.ui.measChannel2.isChecked()
			c3 = self.ui.measChannel3.isChecked()
			c4 = self.ui.measChannel4.isChecked()
			if c1:
				channelVec[0] = 1
			elif c1 == False:
				channelVec[0] = 0
			if c2:
				channelVec[1] = 1
			elif c2 == False:
				channelVec[1] = 0
			if c3:
				channelVec[2] = 1
			elif c3 == False:
				channelVec[2] = 0
			if c4:
				channelVec[3] = 1
			elif c4 == False:
				channelVec[3] = 0
			
			#define dictionaries
			cal = {
				"ToneSpacing" : self.ui.toneSpacing_hetero.text(),
				"StartingToneFreq" : self.ui.startTone_hetero.text(),
				"EndingToneFreq" : self.ui.endTone_hetero.text(),
				"RealBasisFlag" : self.ui.realBasisFlag_hetero.currentIndex(),
				"PhaseDistr" : self.ui.phaseDistribution_hetero.currentIndex(),
				"PAPRmin" : self.ui.paprMin_hetero.text(),
				"PAPRmax" : self.ui.paprMax_hetero.text(),
				"FreqRes" : self.ui.freqResolution_hetero.text(),
				"NumIterations" : self.ui.noIterations_hetero.text(),
				"SaveLocation" : self.ui.upCalSaveLocField_vsgMeas.text(),
				"rxCalFlag" : self.ui.vsaCalFileEnable_hetero.currentIndex(),
				"rxCalFile" : self.ui.vsaCalFileField_vsgMeas_2.text()
			}
			tx={
				"Type": self.ui.vsgSetup.currentIndex(),
				"Model": self.ui.partNum_awg.text(),
				"Fsample" : self.ui.maxSampleRate_awg.text(),
				"ReferenceClockSource": self.ui.refClockSorce_awg.currentIndex(),
				"ReferenceClock": self.ui.extRefFreq_awg.text(),
				"VFS": vfsField,	
				"TriggerAmplitude": trigAmpField,
				"NumberOfTransmittedPeriods": self.ui.noTXPeriods_hetero.text(),
				"ExpansionMarginEnable": self.ui.expansionMarginEnable_hetero.currentIndex(),
				"ExpansionMargin" : self.ui.expansionMargin_hetero.text(),
				"Fcarrier" : self.ui.vsgCenterFreq_hetero.text(),
				"AWG_Channel" : self.ui.awgChannel_awgCal.text()
			}
			rx={
				"Type" : self.ui.vsaType.currentIndex(),
				"FCarrier" : fCarrierField,
				"MirrorSignalFlag" : self.ui.mirrorFlag_hetero.currentIndex(),
				"XCorrLength" : self.ui.xCorrLength_vsgMeas.text(),
				"FSample" : fSampleField,
				"MeasuredPeriods" : self.ui.noRXPeriods_hetero.text(),
				"VisaAddress": addressField,
				"EnableExternalClock_Scope" : self.ui.extClkEnabled_scope.currentIndex(),
				"TriggerChannel" : self.ui.trigChannel_scope.text(),
				"ChannelVec": channelVec,
				"EnableExternalClock_Dig" : self.ui.clockEnabled_dig.currentIndex(),
				"ExternalClockFrequency" : self.ui.clockFreq_dig.currentIndex(),
				"ACDCCoupling" : self.ui.coupling_dig.currentIndex(),
				"VFS" : self.ui.vfs_dig.text(),
				"Interleaving" : self.ui.interleaving_dig.currentIndex(),
				"AnalysisBandwidth":self.ui.analysisBandwidth_sa.text(),
				"Attenuation":self.ui.attenuation_sa.text(),
				"ClockReference":self.ui.clockRef_sa.currentIndex(),
				"TriggerLevel":self.ui.trigLevel_sa.text(),
				"IFPath":self.ui.ifPath_vsa.currentIndex(),
				"AlignFreqDomainFlag" : self.ui.freqDomainAlign_hetero.currentIndex(),
				"DownconversionFilterFile" : self.ui.downFileField_vsgMeas.text()
			}

			matlab.Set_Heterodyne_Calibration(cal,tx,rx,nargout=0)
			#matlab.Upconverter_Calibration_Main(nargout=0)
			
			# create progress bar
			progressBar = QProgressBar()
			progressBar.setRange(0,11);
			progressBar.setTextVisible(True);
			self.ui.statusBar.addWidget(progressBar,1)
			
			# create thread to run signal generation routine
			self.heterodyneThread = runHeterodyneCalibrationThread(progressBar,self,boxDone)
			# connect signals to the thread
			# as routine is run, update progress bar and step
			self.heterodyneThread.updateBar.connect(updateHeterodyneBar)
			# when nmse and papr are available, update gui
			# self.heterodyneThread.updateData.connect(updateHeterodyneData)
			# if error occurs, break thread and alery
			self.heterodyneThread.errorOccurred.connect(errorOccurred)
			# begin running signal generation
			self.heterodyneThread.start()	
			
			# self.progressBar = QProgressBar()
			# self.progressBar.setRange(1,10);
			# self.progressBar.setTextVisible(True);
			# self.progressBar.setFormat("Currently Running: Heterodyne Calibration Routine")
			# self.ui.statusBar.addWidget(self.progressBar,1)
			# completed = 0
			# while completed < 100:
				# completed = completed + 0.00001
				# self.progressBar.setValue(completed)
			# self.ui.statusBar.removeWidget(self.progressBar)
			## to show progress bar, need both addWidget() and show()
			# self.ui.statusBar.showMessage("Heterodyne Calibration Routine Complete",3000)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
	elif setButton.isChecked() == False:
		setButton.setText("Set && Run")
		self.ui.calEquip_hetero.setStyleSheet(None)
		self.ui.rxEquip_hetero.setStyleSheet(None)
		self.ui.vsgEquip_hetero.setStyleSheet(None)
		self.ui.upCalEquipHetero_hetero.setStyleSheet(None)
		self.ui.upEquip_hetero.setStyleSheet(None)
		self.ui.upMark_vsgMeas.setVisible(False)
		self.ui.psgMark_vsgMeas.setVisible(False)
		self.ui.debugVSGStack.setCurrentIndex(2)
		self.ui.vsgMeasNextStack.setCurrentIndex(7)
		
def setHomo(self,boxDone,setButton):
	
	checkDic = [
		self.ui.comboBox_143,
		self.ui.lineEdit_186,
		self.ui.lineEdit_187,
		self.ui.lineEdit_188,
		self.ui.lineEdit_189,
		self.ui.lineEdit_190,
		self.ui.lineEdit_191,
		self.ui.lineEdit_192,
		self.ui.lineEdit_193,
		self.ui.lineEdit_194,
		self.ui.lineEdit_195,
		self.ui.lineEdit_196,
		self.ui.lineEdit_197,
		self.ui.lineEdit_198,
		self.ui.comboBox_142,
		self.ui.lineEdit_199,
		self.ui.comboBox_150,
		self.ui.lineEdit_200,
		self.ui.downFileField_vsgMeas_2,
		self.ui.lineEdit_201,
		self.ui.lineEdit_202,
		self.ui.lineEdit_203,
		self.ui.lineEdit_204,
		self.ui.lineEdit_205,
		self.ui.lineEdit_206,
		self.ui.lineEdit_207,
		self.ui.lineEdit_208,
		self.ui.lineEdit_209,
		self.ui.comboBox_152,
		self.ui.calFileIField_vsgMeas,
		self.ui.calFileQField_vsgMeas,
		self.ui.comboBox_151,
		self.ui.vsaCalFielField_vsgMeas,
		self.ui.iqFileField_vsgMeas_3,
		self.ui.comboBox_148,
		self.ui.lineEdit_214,
		self.ui.lineEdit_215,
		self.ui.comboBox_146,
		self.ui.lineEdit_216,
		self.ui.lineEdit_217,
		self.ui.lineEdit_218,
		self.ui.lineEdit_219,
		self.ui.lineEdit_220,
		self.ui.lineEdit_221,
		self.ui.comboBox_149,
		self.ui.comboBox_147,
		self.ui.lineEdit_222,	
		self.ui.lineEdit_260,
		self.ui.iqSaveLocField_vsgMeas_3,
		self.ui.vsgCalSaveLocField_vsgMeas_3,
		self.ui.calStructSaveLocField_vsgMeas_3
	]
	
	if setButton.isChecked() == True:
		done = win.checkIfDone(checkDic)
		if done:
			setButton.setText("Unset")
			


			self.ui.calEquip_homo.setStyleSheet(boxDone)
			self.ui.rxEquip_homo.setStyleSheet(boxDone)
			self.ui.vsgEquip_homo.setStyleSheet(boxDone)
			self.ui.upCalEquipHomo_homo.setStyleSheet(boxDone)
			self.ui.upEquip_homo.setStyleSheet(boxDone)
			self.ui.scopeEquip_homo.setStyleSheet(boxDone)
			self.ui.vsgMeasNextStack.setCurrentIndex(8)
			self.ui.debugVSGStack.setCurrentIndex(1)
			self.ui.vsgResultsFileStack_vsgMeas.setCurrentIndex(0)
			self.ui.vsgCalPaths_algo.setCurrentIndex(0)
			self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
			self.ui.upMark_vsgMeas.setVisible(True)
			self.ui.psgMark_vsgMeas.setVisible(True)
			
			self.progressBar = QProgressBar()
			self.progressBar.setRange(1,10);
			self.progressBar.setTextVisible(True);
			self.progressBar.setFormat("Currently Running: Homodyne Calibration Routine")
			self.ui.statusBar.addWidget(self.progressBar,1)
			completed = 0
			while completed < 100:
				completed = completed + 0.00001
				self.progressBar.setValue(completed)
			self.ui.statusBar.removeWidget(self.progressBar)
			# to show progress bar, need both addWidget() and show()
			self.ui.statusBar.showMessage("Homodyne Calibration Routine Complete",3000)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)
	elif setButton.isChecked() == False:
		setButton.setText("Set && Run")
		self.ui.calEquip_homo.setStyleSheet(None)
		self.ui.rxEquip_homo.setStyleSheet(None)
		self.ui.vsgEquip_homo.setStyleSheet(None)
		self.ui.upCalEquipHomo_homo.setStyleSheet(None)
		self.ui.upEquip_homo.setStyleSheet(None)
		self.ui.scopeEquip_homo.setStyleSheet(None)
		self.ui.upMark_vsgMeas.setVisible(False)
		self.ui.psgMark_vsgMeas.setVisible(False)
		self.ui.debugVSGStack.setCurrentIndex(2)
		self.ui.vsgMeasNextStack.setCurrentIndex(7)
		
def calValPreview(self):
	self.ui.calValTabs.setCurrentIndex(0)
	self.ui.resultsAlgoTabs.setCurrentIndex(2)
	self.ui.calValResultsStack.setCurrentIndex(0)
	
def runCalValidation(self,setBox,setButton,matlab):
	checkDic = [
		self.ui.comboBox_68,
		self.ui.comboBox_112,
		self.ui.vsaCalFileField_algo,
		self.ui.comboBox_113,
		self.ui.calFileIField_algo,
		self.ui.calFileQField_algo,
		self.ui.lineEdit_246,
		self.ui.comboBox_85,
		self.ui.comboBox_114,
		self.ui.lineEdit_249,
		self.ui.lineEdit_248,
		self.ui.downFileField_algo,
		self.ui.comboBox,
		self.ui.comboBox_2,
		self.ui.lineEdit_245,
		self.ui.lineEdit_250,
		self.ui.comboBox_117,
		self.ui.comboBox_116,
		self.ui.lineEdit_251,
		self.ui.comboBox_118,
		self.ui.lineEdit_252,
	]
	done = win.checkIfDone(checkDic)
	if setButton.isChecked() == True:
		if done:
			setButton.setText("Unset")
			self.ui.calValTabs.setCurrentIndex(0)
			self.ui.resultsAlgoTabs.setCurrentIndex(2)
			self.ui.algoNextStack.setCurrentIndex(1)
			self.ui.debugAlgoStack.setCurrentIndex(0)
			self.ui.calValResultsStack.setCurrentIndex(0)
			self.ui.calValSignalEquip.setStyleSheet(setBox)
			self.ui.calValCalFilesEquip.setStyleSheet(setBox)
			self.ui.calValRefRXEquip.setStyleSheet(setBox)
			self.ui.calValVSGEquip.setStyleSheet(setBox)
			
			self.progressBar = QProgressBar()
			self.progressBar.setRange(1,10);
			self.progressBar.setTextVisible(True);
			self.progressBar.setFormat("Currently Running: Calibration Validation Routine")
			self.ui.statusBar.addWidget(self.progressBar,1)
			completed = 0
			while completed < 100:
				completed = completed + 0.00001
				self.progressBar.setValue(completed)
			self.ui.statusBar.removeWidget(self.progressBar)
			# to show progress bar, need both addWidget() and show()
			self.ui.statusBar.showMessage("Calibration Validation Routine Complete",3000)
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)	
	elif setButton.isChecked() == False:
		setButton.setText("Set && Run")
		self.ui.calValSignalEquip.setStyleSheet(None)
		self.ui.calValCalFilesEquip.setStyleSheet(None)
		self.ui.calValRefRXEquip.setStyleSheet(None)
		self.ui.calValVSGEquip.setStyleSheet(None)
		self.ui.algoNextStack.setCurrentIndex(0)
		self.ui.debugAlgoStack.setCurrentIndex(2)

def preCharPreview(self,matlab):	
	# d = {
		# "signalName": self.ui.comboBox_81.currentIndex(),
	# }
	# matlab.Set_Prechar_Signal(d,nargout=0)
	
	ampCorrField = ""
	trigAmpField = ""
	fCarrierField = ""
	fSampleField = ""
	addressField = ""
	
	# choose proper fields from stacked widgets to be sent to dictionaries
	awgPage = self.ui.awgParamsStack_vsgMeas.currentIndex()
	if awgPage == 1:
		ampCorrField = self.ui.ampCorrection_awgCal.currentIndex()
		trigAmpField = self.ui.trigAmp_awgCal.text()
	elif awgPage == 2:
		ampCorrField = self.ui.ampCorrection_awgCal_2.currentIndex()
		trigAmpField = self.ui.trigAmp_awgCal_2.text()
	vsaPage = self.ui.vsaMeasGenStack.currentIndex()
	if vsaPage == 1:
		fCarrierField = self.ui.centerFreq_vsaMeas.text()
		fSampleField = self.ui.sampRate_vsaMeas.text()
	elif vsaPage == 0:
		fCarrierField = self.ui.centerFreq_vsaMeas_2.text()
		fSampleField = self.ui.sampRate_vsaMeas_2.text()
	vsaType = self.ui.vsaType.currentIndex()
	if vsaType == 1 or vsaType == 5:
		addressField = self.ui.address_scope.text()
	elif vsaType == 2 or vsaType == 6:
		addressField = self.ui.address_dig.text()
	elif vsaType == 3 or vsaType == 4:
		addressField = self.ui.address_sa.text()
	
	tx={
		"Type": self.ui.vsgSetup.currentIndex(),
		"Model": self.ui.partNum_awg.text(),
		"FGuard" : self.ui.guardBand_prechar.text(),
		"FCarrier" : self.ui.centerFreq_prechar.text(),
		"FSampleDAC" : self.ui.maxSampleRate_awg.text(),
		"NumberOfSegments" : self.ui.noSegments_prechar.text(),
		"Amp_Corr" : ampCorrField,
		"GainExpansion_flag" : self.ui.gainExpansionFlag_prechar.currentIndex(),
		"GainExpansion" : self.ui.gainExpansion_prechar.text(),
		"FreqMutiplierFlag" : self.ui.freqMultiplierFlag_prechar.currentIndex(),
		"FreqMultiplierFactor": self.ui.freqMultiplierFactor_prechar.text(),	
		"ReferenceClockSource": self.ui.refClockSorce_awg.currentIndex(),	
		"iChannel": self.ui.iChannel_awg.currentIndex(),	
		"qChannel": self.ui.qChannel_awg.currentIndex(),	
		"ReferenceClock": self.ui.extRefFreq_awg.text(),	
		"VFS": self.ui.dacRange_awg.text(),	
		"TriggerAmplitude": trigAmpField
	}
	rx={
		"Type" : self.ui.vsaType.currentIndex(),
		"FCarrier" : fCarrierField,
		"MirrorSignalFlag" : self.ui.mirrorSignal_prechar.currentIndex(),
		"FSample" : fSampleField,
		"MeasuredPeriods" : self.ui.noPeriods_prechar.text(),
		"xLength" : self.ui.crossCorrLength_prechar.text(),
		"FsampleOverwrite" : self.ui.sampRateOverwrite_prechar.currentIndex(),
		"SubRate" : self.ui.subRate_prechar.currentIndex(),
		"AlignFreqDomainFlag" : self.ui.alignFreqDomain_prechar.currentIndex(),
		"DownconversionFilterFile" : self.ui.downFileField_algo_2.text(),
		"TriggerChannel" : self.ui.trigChannel_scope.text(),
		"ASMPath" : self.ui.dllFile_uxa.text(),
		"SetupFile" : self.ui.setupFile_uxa.text(),
		"DataFile" : self.ui.dataFile_uxa.text(),
		"DemodSignalFlag": self.ui.demodulationEnable.currentIndex(),
		"VisaAddress": addressField
		
	}
	dSignal = {
		"signalName": self.ui.comboBox_81.currentIndex(),
	}
	# set signal dictionary
	matlab.Set_Prechar_Signal(dSignal,nargout=0)
	# set signal generation dictionary
	matlab.Set_RXTX_Structures(tx,rx,nargout=0)
	result = matlab.Preview_Prechar_Signal(nargout=1)
	print(result)
	if result != "":
		instrParamErrorMessage(self,result)
	else:
		spectrumImage = mpimg.imread('.\Figures\Prechar_Spectrum_Input.png')
		self.precharSpectrumFigure.clear()
		ax = self.precharSpectrumFigure.add_subplot(111)
		ax.imshow(spectrumImage)
		ax.set_xlabel('Frequency(GHz)')
		ax.set_ylabel('Power(dB)')
		ax.set_title('Welch Mean-Square Spectrum Estimate')
		ax.set_xticks([], [])
		ax.set_yticks([], [])
		self.precharSpectrumCanvas.draw()
		 
		self.ui.precharTabs.setCurrentIndex(0)
		self.ui.resultsAlgoTabs.setCurrentIndex(3)
		self.ui.precharAlgoStack.setCurrentIndex(0)
	
def runPrecharacterization(self,setBox,setButton,matlab):
	ampCorrField = ""
	trigAmpField = ""
	fCarrierField = ""
	fSampleField = ""
	addressField = ""
	
	rfOn = self.ui.emergButtonSecond.isChecked()
	checkDic = [
		self.ui.comboBox_81,
		self.ui.comboBox_121,
		self.ui.vsaCalFileField_algo_2,
		self.ui.comboBox_122,
		self.ui.calFileIField_algo_2,
		self.ui.calFileQField_algo_2,
		self.ui.noPeriods_prechar,
		self.ui.mirrorSignal_prechar,
		self.ui.alignFreqDomain_prechar,
		self.ui.guardBand_prechar,
		self.ui.crossCorrLength_prechar,
		self.ui.downFileField_algo_2,
		self.ui.subRate_prechar,
		self.ui.sampRateOverwrite_prechar,
		self.ui.noSegments_prechar,
		self.ui.centerFreq_prechar,
		self.ui.gainExpansionFlag_prechar,
		self.ui.gainExpansion_prechar,
		self.ui.freqMultiplierFlag_prechar,
		self.ui.freqMultiplierFactor_prechar
	]
	done = win.checkIfDone(checkDic)
	
	if setButton.isChecked() == True:
		if done:
			if rfOn == False:
				instrParamErrorMessage(self,"Turn on RF before attempting to run precharacterization setup.")
				self.ui.emergButtonSecond.setChecked(False)
				return
			# choose proper fields from stacked widgets to be sent to dictionaries
			awgPage = self.ui.awgParamsStack_vsgMeas.currentIndex()
			if awgPage == 1:
				ampCorrField = self.ui.ampCorrection_awgCal.currentIndex()
				trigAmpField = self.ui.trigAmp_awgCal.text()
			elif awgPage == 2:
				ampCorrField = self.ui.ampCorrection_awgCal_2.currentIndex()
				trigAmpField = self.ui.trigAmp_awgCal_2.text()
			vsaPage = self.ui.vsaMeasGenStack.currentIndex()
			if vsaPage == 1:
				fCarrierField = self.ui.centerFreq_vsaMeas.text()
				fSampleField = self.ui.sampRate_vsaMeas.text()
			elif vsaPage == 0:
				fCarrierField = self.ui.centerFreq_vsaMeas_2.text()
				fSampleField = self.ui.sampRate_vsaMeas_2.text()
			vsaType = self.ui.vsaType.currentIndex()
			if vsaType == 1 or vsaType == 5:
				addressField = self.ui.address_scope.text()
			elif vsaType == 2 or vsaType == 6:
				addressField = self.ui.address_dig.text()
			elif vsaType == 3 or vsaType == 4:
				addressField = self.ui.address_sa.text()
			# define all relevant dictionaries
			tx={
				"Type": self.ui.vsgSetup.currentIndex(),
				"Model": self.ui.partNum_awg.text(),
				"FGuard" : self.ui.guardBand_prechar.text(),
				"FCarrier" : self.ui.centerFreq_prechar.text(),
				"FSampleDAC" : self.ui.maxSampleRate_awg.text(),
				"NumberOfSegments" : self.ui.noSegments_prechar.text(),
				"Amp_Corr" : ampCorrField,
				"GainExpansion_flag" : self.ui.gainExpansionFlag_prechar.currentIndex(),
				"GainExpansion" : self.ui.gainExpansion_prechar.text(),
				"FreqMutiplierFlag" : self.ui.freqMultiplierFlag_prechar.currentIndex(),
				"FreqMultiplierFactor": self.ui.freqMultiplierFactor_prechar.text(),	
				"ReferenceClockSource": self.ui.refClockSorce_awg.currentIndex(),	
				"iChannel": self.ui.iChannel_awg.currentIndex(),	
				"qChannel": self.ui.qChannel_awg.currentIndex(),	
				"ReferenceClock": self.ui.extRefFreq_awg.text(),	
				"VFS": self.ui.dacRange_awg.text(),	
				"TriggerAmplitude": trigAmpField
			}
			rx={
				"Type" : self.ui.vsaType.currentIndex(),
				"FCarrier" : fCarrierField,
				"MirrorSignalFlag" : self.ui.mirrorSignal_prechar.currentIndex(),
				"FSample" : fSampleField,
				"MeasuredPeriods" : self.ui.noPeriods_prechar.text(),
				"xLength" : self.ui.crossCorrLength_prechar.text(),
				"FsampleOverwrite" : self.ui.sampRateOverwrite_prechar.currentIndex(),
				"SubRate" : self.ui.subRate_prechar.currentIndex(),
				"AlignFreqDomainFlag" : self.ui.alignFreqDomain_prechar.currentIndex(),
				"DownconversionFilterFile" : self.ui.downFileField_algo_2.text(),
				"TriggerChannel" : self.ui.trigChannel_scope.text(),
				"ASMPath" : self.ui.dllFile_uxa.text(),
				"SetupFile" : self.ui.setupFile_uxa.text(),
				"DataFile" : self.ui.dataFile_uxa.text(),
				"DemodSignalFlag": self.ui.demodulationEnable.currentIndex(),
				"VisaAddress": addressField
				
			}
			dSignal = {
				"signalName": self.ui.comboBox_81.currentIndex(),
			}
			# set signal dictionary
			matlab.Set_Prechar_Signal(dSignal,nargout=0)
			# set signal generation dictionary
			matlab.Set_RXTX_Structures(tx,rx,nargout=0)
			
			# make debugging panel visible
			self.ui.debugAlgoStack.setCurrentIndex(0)
			
			# create progress bar
			progressBar = QProgressBar()
			progressBar.setRange(0,7);
			progressBar.setTextVisible(True);
			self.ui.statusBar.addWidget(progressBar,1)
			
			# create thread to run signal generation routine
			self.precharThread = runSignalGenerationThread(progressBar,self,setBox)
			# connect signals to the thread
			# as routine is run, update progress bar and step
			self.precharThread.updateBar.connect(updatePrecharBar)
			# when nmse and papr are available, update gui
			self.precharThread.updateData.connect(updatePrecharData)
			# if error occurs, break thread and alery
			self.precharThread.errorOccurred.connect(errorOccurred)
			# begin running signal generation
			self.precharThread.start()	
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)	
	elif setButton.isChecked() == False:
		setButton.setText("Set && Run")
		self.ui.algoNextStack.setCurrentIndex(2)
		self.ui.debugAlgoStack.setCurrentIndex(2)
		self.ui.precharSignalEquip.setStyleSheet(None)
		self.ui.precharCalFilesEquip.setStyleSheet(None)
		self.ui.precharRefRXEquip.setStyleSheet(None)
		self.ui.precharVSGEquip.setStyleSheet(None)
		
def dpdPreview(self):
	self.ui.dpdTabs.setCurrentIndex(0)
	self.ui.resultsAlgoTabs.setCurrentIndex(4)
	self.ui.dpdAlgoStack.setCurrentIndex(0)
	
def runDPD(self,setBox,setButton,matlab):

	checkDic = [
		self.ui.comboBox_130,
		self.ui.comboBox_131,
		self.ui.customIField_algo,
		self.ui.customQField_algo,
		self.ui.comboBox_132,
		self.ui.vsaCalFileField_algo_3,
		self.ui.comboBox_133,
		self.ui.calFileIField_algo_3,
		self.ui.calFileQField_algo_3,
		self.ui.comboBox_134,
		self.ui.lineEdit_263,
		self.ui.lineEdit_264,
		self.ui.lineEdit_265,
		self.ui.lineEdit_266,
		self.ui.downFileField_algo_3,
		self.ui.comboBox_84,
		self.ui.comboBox_128,
		self.ui.lineEdit_267,
		self.ui.lineEdit_268,
		self.ui.comboBox_135,
		self.ui.comboBox_136,
		self.ui.lineEdit_269,
		self.ui.comboBox_138,
		self.ui.lineEdit_270,
		self.ui.lineEdit_284,
		self.ui.lineEdit_283,
		self.ui.comboBox_140,
		self.ui.comboBox_129,
		self.ui.comboBox_139,
		self.ui.comboBox_141,
		self.ui.comboBox_154,
		self.ui.comboBox_153,
		self.ui.comboBox_155,
		self.ui.lineEdit_282,
		self.ui.lineEdit_281,
		self.ui.lineEdit_280,
		self.ui.lineEdit_279,
		self.ui.lineEdit_278,
		self.ui.comboBox_156,
		self.ui.comboBox_157,
		self.ui.comboBox_158,
		self.ui.comboBox_159,
		self.ui.lineEdit_277,
		self.ui.lineEdit_276,
		self.ui.lineEdit_275,
		self.ui.comboBox_161,
		self.ui.comboBox_162,
		self.ui.lineEdit_274,
		self.ui.comboBox_160,
		self.ui.lineEdit_273,
		self.ui.lineEdit_272,
		self.ui.lineEdit_271
	]
	done = win.checkIfDone(checkDic)
	
	if setButton.isChecked() == True:
		if done:
			setButton.setText("Unset")
			self.ui.dpdTabs.setCurrentIndex(0)
			self.ui.resultsAlgoTabs.setCurrentIndex(4)
			self.ui.algoNextStack.setCurrentIndex(5)
			self.ui.debugAlgoStack.setCurrentIndex(1)
			self.ui.dpdAlgoStack.setCurrentIndex(0)
			self.ui.dpdSignalEquip.setStyleSheet(setBox)
			self.ui.dpdCalFilesEquip.setStyleSheet(setBox)
			self.ui.dpdGeneralEquip.setStyleSheet(setBox)
			self.ui.dpdModelEquip.setStyleSheet(setBox)
			self.ui.dpdAWGEquip.setStyleSheet(setBox)
			self.ui.dpdRefRXEquip.setStyleSheet(setBox)
			self.ui.dpdVSGEquip.setStyleSheet(setBox)
			self.ui.dpdTrainingEquip.setStyleSheet(setBox)
			
			self.progressBar = QProgressBar()
			self.progressBar.setRange(1,10);
			self.progressBar.setTextVisible(True);
			self.progressBar.setFormat("Currently Running: PreCharacterization Setup Routine")
			self.ui.statusBar.addWidget(self.progressBar,1)
			completed = 0
			while completed < 100:
				completed = completed + 0.00001
				self.progressBar.setValue(completed)
			self.ui.statusBar.removeWidget(self.progressBar)
			# to show progress bar, need both addWidget() and show()
			self.ui.statusBar.showMessage("PreCharacterization Setup Routine Complete",3000)	
		else:
			instrParamErrorMessage(self,"Please fill out all fields before attempting to set parameters.")
			setButton.setChecked(False)	
	elif setButton.isChecked() == False:
		setButton.setText("Set && Run")
		self.ui.algoNextStack.setCurrentIndex(4)
		self.ui.debugAlgoStack.setCurrentIndex(2)
		self.ui.dpdSignalEquip.setStyleSheet(None)
		self.ui.dpdCalFilesEquip.setStyleSheet(None)
		self.ui.dpdGeneralEquip.setStyleSheet(None)
		self.ui.dpdModelEquip.setStyleSheet(None)
		self.ui.dpdAWGEquip.setStyleSheet(None)
		self.ui.dpdRefRXEquip.setStyleSheet(None)
		self.ui.dpdVSGEquip.setStyleSheet(None)
		self.ui.dpdTrainingEquip.setStyleSheet(None)
		
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions for setParameters.py	

def setPrevVSAButtons(self,colour1,cursor1,colour2,cursor2,colour3,cursor3):
	# vsa buttons
	setColourAndCursor(self,self.ui.vsaButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_up_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_up_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_up_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_up_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.uxaButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.uxaButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.pxaButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.pxaButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.modButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.modButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.vsaButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_vsg_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_vsg_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.scopeButton_vsg_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_vsg_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_vsg_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.digButton_vsg_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.uxaButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.uxaButton_vsg_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.pxaButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.pxaButton_vsg_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.modButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.modButton_vsg_2,colour1,cursor1)
	# down buttons
	setColourAndCursor(self,self.ui.downButton_vsa,colour2,cursor2)
	setColourAndCursor(self,self.ui.downButton_vsa_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.downButton_up,colour2,cursor2)
	setColourAndCursor(self,self.ui.downButton_up_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.downButton_vsg,colour2,cursor2)
	setColourAndCursor(self,self.ui.downButton_vsg_2,colour2,cursor2)
	# meter buttons
	setColourAndCursor(self,self.ui.meterButton_vsa,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsa_2,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsa_3,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsa_4,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsa_5,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_up,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_up_2,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_up_3,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_up_4,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_up_5,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsg,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsg_2,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsg_3,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsg_4,colour3,cursor3)
	setColourAndCursor(self,self.ui.meterButton_vsg_5,colour3,cursor3)
	
def setPrevDownButtons(self,colour1,cursor1,colour2,cursor2):
	# down buttons
	setColourAndCursor(self,self.ui.downButton_vsa,colour1,cursor1)
	setColourAndCursor(self,self.ui.downButton_vsa_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.downButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.downButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.downButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.downButton_vsg_2,colour1,cursor1)
	# meter buttons
	setColourAndCursor(self,self.ui.meterButton_down,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_down_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsa,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsa_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsa_3,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsa_4,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsa_5,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_up,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_up_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_up_3,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_up_4,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_up_5,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsg,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsg_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsg_3,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsg_4,colour2,cursor2)
	setColourAndCursor(self,self.ui.meterButton_vsg_5,colour2,cursor2)
	
def setPrevMeterButtons(self,colour1,cursor1,colour2,cursor2):
	# meter buttons
	setColourAndCursor(self,self.ui.meterButton_down,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_down_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsa,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsa_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsa_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsa_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsa_5,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_up_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_up_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_up_5,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsg_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsg_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsg_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.meterButton_vsg_5,colour1,cursor1)
	# sa buttons
	setColourAndCursor(self,self.ui.saButton_vsg,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsg_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsg_3,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsg_4,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsg_5,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_up,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_up_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_up_3,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_up_4,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_up_5,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsa,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsa_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsa_3,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsa_4,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_vsa_5,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_down,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_down_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_meter,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_meter_2,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_meter_3,colour2,cursor2)
	setColourAndCursor(self,self.ui.saButton_meter_4,colour2,cursor2)

def	setPrevSAButtons(self,colour1,cursor1,colour2,cursor2):
	# sa buttons
	setColourAndCursor(self,self.ui.saButton_vsg,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsg_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsg_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsg_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsg_5,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_up,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_up_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_up_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_up_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_up_5,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsa,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsa_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsa_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsa_4,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_vsa_5,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_down,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_down_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_meter,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_meter_2,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_meter_3,colour1,cursor1)
	setColourAndCursor(self,self.ui.saButton_meter_4,colour1,cursor1)
	# power 1 buttons
	setColourAndCursor(self,self.ui.power1Button_sa,colour2,cursor2)
	setColourAndCursor(self,self.ui.power1Button_meter,colour2,cursor2)
	setColourAndCursor(self,self.ui.power1Button_down,colour2,cursor2)
	setColourAndCursor(self,self.ui.power1Button_vsa,colour2,cursor2)
	setColourAndCursor(self,self.ui.power1Button_up,colour2,cursor2)
	setColourAndCursor(self,self.ui.power1Button_vsg,colour2,cursor2)
	
def setPrevP1Buttons(self,buttonColourOne,buttonColourTwo,buttonColourThree,cursorOne,cursorTwo):
	setFocusAndHand(self,self.ui.power1Button_sa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_meter,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_down,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_up,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsg,buttonColourOne)
	
	setColourAndCursor(self,self.ui.power2Button_p1,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_p1_2,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_sa,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_sa_2,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_meter_2,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_meter,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_down,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_down_2,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_vsa,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_vsa_2,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_up,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_vsg,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power2Button_vsg_2,buttonColourTwo,cursorOne)
	setColourAndCursor(self,self.ui.power3Button_p1,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_p1_2,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_sa,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_sa_2,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_meter_2,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_meter,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_down,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_down_2,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_vsa,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_vsa_2,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_up,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_up_2,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_vsg,buttonColourThree,cursorTwo)
	setColourAndCursor(self,self.ui.power3Button_vsg_2,buttonColourThree,cursorTwo)
	
def unsetPrevP1Buttons(self,buttonColourOne):
	setFocusAndHand(self,self.ui.power1Button_sa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_meter,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_down,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_up,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsg,buttonColourOne)

def setPrevP2Buttons(self,buttonColourOne,buttonColourTwo):
	setFocusAndHand(self,self.ui.power2Button_p1,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_p1_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_sa,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_sa_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_meter_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_meter,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_down,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_down_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsa,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsa_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_up,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsg,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsg_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power3Button_p2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_p2_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_p1,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_p1_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_sa,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_sa_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_meter_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_meter,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_down,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_down_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_vsa,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_vsa_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_up,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_up_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_vsg,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_vsg_2,buttonColourTwo)

def unsetPrevP2Buttons(self,buttonColourOne):
	setFocusAndHand(self,self.ui.power2Button_p1,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_p1_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_sa,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_sa_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_meter_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_meter,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_down,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_down_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsa,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsa_2,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_up,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsg,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_vsg_2,buttonColourOne)
	
def setPrevP3Buttons(self,buttonHover):
	setFocusAndHand(self,self.ui.power3Button_p2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_p2_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_p1,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_p1_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_sa,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_sa_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_meter_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_meter,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_down,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_down_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsa,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsa_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_up,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_up_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsg,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsg_2,buttonHover)	
	
def unsetPrevP3Buttons(self,buttonHover):
	setFocusAndHand(self,self.ui.power3Button_p2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_p2_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_p1,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_p1_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_sa,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_sa_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_meter_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_meter,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_down,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_down_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsa,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsa_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_up,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_up_2,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsg,buttonHover)
	setFocusAndHand(self,self.ui.power3Button_vsg_2,buttonHover)
	
def setColourAndCursor(self,button,colour,cursor):
	button.setStyleSheet(colour)
	button.setCursor(QCursor(cursor))
	
def setFocusAndHand(self,button,colour):
	button.setStyleSheet(colour)
	button.setCursor(QCursor(Qt.PointingHandCursor))

def setAllDemod(self, boxDone):
	self.ui.digMod.setStyleSheet(boxDone)
	self.ui.scopeMod.setStyleSheet(boxDone)
	self.ui.uxaMod.setStyleSheet(boxDone)

def instrParamErrorMessage(self,error):
	msg = QMessageBox(self)
	msg.setIcon(QMessageBox.Critical)
	msg.setWindowTitle('Unable to Set Parameters')
	msg.setText(error)
	msg.setStandardButtons(QMessageBox.Ok)
	msg.exec_();
	
def algoRunErrorMessage(self,error):
	msg = QMessageBox(self)
	msg.setIcon(QMessageBox.Critical)
	msg.setWindowTitle('Unable to Run')
	msg.setText(error)
	msg.setStandardButtons(QMessageBox.Ok)
	msg.exec_();
	
def setSpectrumAnalyzerAdvancedParams(self,dictionary,equipBox,matlab,boxDone):
	result = matlab.Set_Spectrum_Advanced(dictionary,nargout=1)
	result = result.split(";")
	error = result[1]
	if error == " ":
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	else:
		instrParamErrorMessage(self,error)
		self.ui.saSetAdv.setChecked(False)
		
def setSpectrumAnalyzerParams(self,dictionary,partNum,matlab,equipBox,boxDone,model):
	address = dictionary["address"]
	result = matlab.Set_Spectrum(dictionary,model,nargout=1)
	result = result.split(";")
	error = result[1]
	
	if error == " ":
		powerMeterPartNum = result[0]
		partNum.setText(powerMeterPartNum)
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	elif address == "":
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	else:
		instrParamErrorMessage(self,error)
		self.ui.saSet.setChecked(False)
		
def setPowerMeterParams(self,dictionary,partNum,equipBox,boxDone,matlab):	
	address = dictionary["address"]
	result = matlab.Set_Meter(dictionary,nargout=1)
	result = result.split(";")
	error = result[1]

	if error == " " :	
		powerMeterPartNum = result[0]
		partNum.setText(powerMeterPartNum)
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	elif address == "":
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	else:
		instrParamErrorMessage(self,error)
		self.ui.meterSet.setChecked(False)
		
def setSupplyParams(self,address,voltage,current,partNum,equipBox,boxDone,matlab,channel):
	A = address.text()
	V = voltage.text()
	C = current.text()
	
	result = matlab.Set_Supply(A,V,C,channel,nargout=1)
	result = result.split(";")
	error = result[1]
	if error == " ":
		partNumber = result[0]
		partNum.setText(partNumber)
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	else:
		instrParamErrorMessage(self,error)
		self.ui.p1Set.setChecked(False)
		
def setAWGParams(self,dictionary,matlab):
	model = dictionary["model"]
	result = matlab.Set_AWG(dictionary,nargout = 1)
	result = result.split("~")
	partNum = result[0]
	errorString = result[1]
	errorArray = errorString.split("|")
	errors = determineIfErrors(self,errorArray);
	if errors == 0:
		self.ui.partNum_awg.setText(partNum)
		if model == 1:
			self.ui.maxSampleRate_awg.setText("8e9")
		elif model == 2:
			self.ui.maxSampleRate_awg.setText("12e9")
		flag = 1
	else:
		addToErrorLayout(self,errorArray)
		self.ui.awgSetGeneral.setChecked(False)
		flag = 0
	return flag
		
def setAdvAWGParams(self,dictionary,matlab):
	errorString = matlab.Set_AdvAWG(dictionary,nargout=1)
	errorArray = errorString.split("|")
	errors = determineIfErrors(self,errorArray);
	if errors == 0:
		flag = 1
		return flag
	else:
		addToErrorLayout(self,errorArray)
		self.ui.awgSetAdv.setChecked(False)
		
def determineIfErrors(self,errorArray):
	errors = 0
	for x in errorArray:
		if x == "" or x == " ":
			continue
		else:
			errors =1
	return errors
	
def addToErrorLayout(self,errorArray):
	for x in errorArray:
		if x == "" or x == " ":
			continue
		else:
			instrParamErrorMessage(self,x)
			label = QLabel()
			label.setText(x)
			label.setAlignment(Qt.AlignTop)
			self.ui.errorLayout.addWidget(label)
			
def updatePrecharBar(self,stepNumber,bar,setBox):
	if stepNumber == "0": 
		bar.setValue(float(stepNumber))
		bar.setFormat("Currently Running: Set Parameters")
	elif stepNumber == "1":
		bar.setFormat("Currently Running: Prepare Signal for Upload")
		bar.setValue(float(stepNumber))
		
		# style parameter boxes that were set in step 0
		self.ui.precharSignalEquip.setStyleSheet(setBox)
		self.ui.precharCalFilesEquip.setStyleSheet(setBox)
		self.ui.precharRefRXEquip.setStyleSheet(setBox)
		self.ui.precharVSGEquip.setStyleSheet(setBox)
		self.ui.precharRun.setText("Unset")
		
		# switch to prechar tab
		self.ui.precharTabs.setCurrentIndex(0)
		self.ui.resultsAlgoTabs.setCurrentIndex(3)
		
	elif stepNumber == "2":
		bar.setFormat("Currently Running: Upload Signal")
		bar.setValue(float(stepNumber))
	elif stepNumber == "3":
		bar.setFormat("Currently Running: Download Signal")
		bar.setValue(float(stepNumber))
	elif stepNumber == "4":
		bar.setFormat("Currently Running: Align & Analyze Signals")
		bar.setValue(float(stepNumber))
	elif stepNumber == "5":
		bar.setFormat("Currently Running: Save Spectrum & VSA Data")
		bar.setValue(float(stepNumber))
		
		# embed plots into GUI (created in step 4)
		spectrumImage = mpimg.imread('.\Figures\Prechar_Spectrum_Output.png')
		self.precharSpectrumFigure.clear()
		sax = self.precharSpectrumFigure.add_subplot(111)
		sax.imshow(spectrumImage)
		sax.set_xlabel('Frequency(GHz)')
		sax.set_ylabel('Power(dB)')
		sax.set_title('Welch Mean-Square Spectrum Estimate')
		sax.set_xticks([], [])
		sax.set_yticks([], [])
		self.precharSpectrumCanvas.draw()
		
		gainImage = mpimg.imread('.\Figures\Prechar_Gain.png')
		self.precharGainFigure.clear()
		gax = self.precharGainFigure.add_subplot(111)
		gax.imshow(gainImage)
		gax.set_xlabel('Input Power (dBm)')
		gax.set_ylabel('Gain Distortion (dB)')
		gax.set_title('Gain Distortion')
		gax.set_xticks([], [])
		gax.set_yticks([], [])
		self.precharGainCanvas.draw()
			
		phaseImage = mpimg.imread('.\Figures\Prechar_Phase.png')
		self.precharPhaseFigure.clear()
		pax = self.precharPhaseFigure.add_subplot(111)
		pax.imshow(phaseImage)
		pax.set_xlabel('Input Power (dBm)')
		pax.set_ylabel('Phase Distortion (degree)')
		pax.set_title('AM/PM Distortion')
		pax.set_xticks([], [])
		pax.set_yticks([], [])
		self.precharPhaseCanvas.draw()
		
		# switch gui page to show plots
		self.ui.precharAlgoStack.setCurrentIndex(0)
		
	elif stepNumber == "6":
		bar.setFormat("Currently Running: Save Signal Generation Measurements")
		bar.setValue(float(stepNumber))
	elif stepNumber == "7":
		bar.setValue(float(stepNumber))
		# remove progress bar
		self.ui.statusBar.removeWidget(bar)
		self.ui.statusBar.showMessage("Routine Complete",3000)
		# change next stack
		self.ui.algoNextStack.setCurrentIndex(3)
		
def updatePrecharData(self,result):
	# add nmse and papr data into GUI
	result = result.split("~")
	nmsePercent = result[1]
	nmseDB = result[2]
	inputPAPR = result[3]
	outputPAPR = result[4]
	nmsePercent = str(round(float(nmsePercent), 2))
	# nmseDB can be -inf, cannot round this so skip
	try:
		nmseDB = str(round(float(nmseDB), 2))
	except:
		pass
	inputPAPR = str(round(float(inputPAPR), 2))
	outputPAPR = str(round(float(outputPAPR), 2))
	
	self.ui.nmsePercent_prechar.setText(nmsePercent)
	self.ui.nmseDB_prechar.setText(nmseDB)
	self.ui.inputPAPR_prechar.setText(inputPAPR)
	self.ui.outputPAPR_prechar.setText(outputPAPR)
	
def updateHeterodyneBar(self,stepNumber,bar,boxDone):
	if stepNumber == "0": 
		bar.setValue(float(stepNumber))
		bar.setFormat("Currently Running: Set Parameters")
	elif stepNumber == "1":
		bar.setFormat("Currently Running: Initialize VSA Drivers")
		bar.setValue(float(stepNumber))
		
		# style parameter boxes that were set in step 0
		self.ui.calEquip_hetero.setStyleSheet(boxDone)
		self.ui.rxEquip_hetero.setStyleSheet(boxDone)
		self.ui.vsgEquip_hetero.setStyleSheet(boxDone)
		self.ui.upCalEquipHetero_hetero.setStyleSheet(boxDone)
		self.ui.upEquip_hetero.setStyleSheet(boxDone)
		self.ui.upMark_vsgMeas.setVisible(True)
		self.ui.psgMark_vsgMeas.setVisible(True)
		
		# switch to heterodyne tab
		self.ui.vsgMeasNextStack.setCurrentIndex(8)
		self.ui.vsgResultsFileStack_vsgMeas.setCurrentIndex(1)
		self.ui.vsgCalPaths_algo.setCurrentIndex(1)
		self.ui.debugVSGStack.setCurrentIndex(0)
		self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
		
	elif stepNumber == "2":
		bar.setFormat("Currently Running: Generate Multi-Tone Signal")
		bar.setValue(float(stepNumber))
	elif stepNumber == "3":
		bar.setFormat("Currently Running: Iteration Loop")
		bar.setValue(float(stepNumber))
	elif stepNumber == "7":
		bar.setFormat("Currently Running: Save Inverse Model Data")
		bar.setValue(float(stepNumber))
	# elif stepNumber == "5":
		# bar.setFormat("Currently Running: Save Spectrum & VSA Data")
		# bar.setValue(float(stepNumber))
		
		# # embed plots into GUI (created in step 4)
		# spectrumImage = mpimg.imread('.\Figures\Prechar_Spectrum_Output.png')
		# self.precharSpectrumFigure.clear()
		# sax = self.precharSpectrumFigure.add_subplot(111)
		# sax.imshow(spectrumImage)
		# sax.set_xlabel('Frequency(GHz)')
		# sax.set_ylabel('Power(dB)')
		# sax.set_title('Welch Mean-Square Spectrum Estimate')
		# sax.set_xticks([], [])
		# sax.set_yticks([], [])
		# self.precharSpectrumCanvas.draw()
		
		# gainImage = mpimg.imread('.\Figures\Prechar_Gain.png')
		# self.precharGainFigure.clear()
		# gax = self.precharGainFigure.add_subplot(111)
		# gax.imshow(gainImage)
		# gax.set_xlabel('Input Power (dBm)')
		# gax.set_ylabel('Gain Distortion (dB)')
		# gax.set_title('Gain Distortion')
		# gax.set_xticks([], [])
		# gax.set_yticks([], [])
		# self.precharGainCanvas.draw()
			
		# phaseImage = mpimg.imread('.\Figures\Prechar_Phase.png')
		# self.precharPhaseFigure.clear()
		# pax = self.precharPhaseFigure.add_subplot(111)
		# pax.imshow(phaseImage)
		# pax.set_xlabel('Input Power (dBm)')
		# pax.set_ylabel('Phase Distortion (degree)')
		# pax.set_title('AM/PM Distortion')
		# pax.set_xticks([], [])
		# pax.set_yticks([], [])
		# self.precharPhaseCanvas.draw()
		
		# # switch gui page to show plots
		# self.ui.precharAlgoStack.setCurrentIndex(0)
		
	# elif stepNumber == "6":
		# bar.setFormat("Currently Running: Save Signal Generation Measurements")
		# bar.setValue(float(stepNumber))
	# elif stepNumber == "7":
		# bar.setValue(float(stepNumber))
		# # remove progress bar
		# self.ui.statusBar.removeWidget(bar)
		# self.ui.statusBar.showMessage("Routine Complete",3000)
		# # change next stack
		# self.ui.algoNextStack.setCurrentIndex(3)
	
def errorOccurred(self,error,bar):
	algoRunErrorMessage(self,error)
	self.ui.statusBar.removeWidget(bar)
	self.ui.statusBar.showMessage("Routine Crashed",3000)
	
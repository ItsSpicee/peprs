# setParameters.py contains all the functions that are called whenever a "set" "set & run" or "preview" button is clicked

from PyQt5.QtWidgets import (QProgressBar)
from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions used in main.py

def setGeneralAWG(self,buttonColourFocus,boxDone,buttonGreyPHover,buttonGreyGHover):
	self.ui.awgButton_vsg.setStyleSheet(buttonColourFocus)
	self.ui.awgButton_vsg_2.setStyleSheet(buttonColourFocus)
	self.ui.awgButton_vsg_3.setStyleSheet(buttonColourFocus)
	setStandardMessage(self)
	self.ui.awgEquipGeneral.setStyleSheet(boxDone)
	setupIdx = self.ui.vsgWorkflows.currentIndex()
	if setupIdx == 1:
		self.ui.vsgNextSteps.setCurrentIndex(5)
		self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	elif setupIdx == 2:
		self.ui.vsgNextSteps.setCurrentIndex(2)
		self.ui.upButton_vsg.setStyleSheet(buttonGreyGHover)
		self.ui.upButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.psgButton_vsg.setStyleSheet(buttonGreyGHover)
		self.ui.psgButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	elif setupIdx == 3:
		self.ui.vsgNextSteps.setCurrentIndex(3)
		self.ui.upButton_vsg.setStyleSheet(buttonGreyGHover)
		self.ui.upButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		self.ui.psgButton_vsg.setStyleSheet(buttonGreyGHover)
		self.ui.psgButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		
def setGeneralVSG(self, buttonColourFocus, boxDone,buttonGreyPHover):
	self.ui.vsgButton_vsg.setStyleSheet(buttonColourFocus)
	self.ui.vsgEquipGeneral.setStyleSheet(boxDone)
	setStandardMessage(self)
	self.ui.vsgNextSteps.setCurrentIndex(5)
	self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover)
	self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))

def setAdvanced(self,box,boxDone):
	box.setStyleSheet(boxDone)
	self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)

def setUp(self,buttonColourFocus,buttonColourDone,boxDone,buttonGreyPHover):
	self.ui.upButton_up.setStyleSheet(buttonColourFocus)
	self.ui.upButton_vsg.setStyleSheet(buttonColourDone)
	self.ui.upEquip.setStyleSheet(boxDone)
	self.ui.up_psg_next.setCurrentIndex(2)
	self.ui.vsgNextSteps.setCurrentIndex(5)
	setStandardMessage(self)
	self.ui.vsaButton_up.setStyleSheet(buttonGreyPHover)
	self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
	self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover)
	self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))

def setPSG(self,buttonColourFocus,buttonColourDone,boxDone,buttonGreyPHover):
	self.ui.psgButton_up.setStyleSheet(buttonColourFocus)
	self.ui.psgButton_vsg.setStyleSheet(buttonColourDone)
	self.ui.psgEquip.setStyleSheet(boxDone)
	self.ui.up_psg_next.setCurrentIndex(2)
	self.ui.vsgNextSteps.setCurrentIndex(5)
	setStandardMessage(self)
	self.ui.vsaButton_up.setStyleSheet(buttonGreyPHover)
	self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
	self.ui.vsaButton_vsg.setStyleSheet(buttonGreyPHover)
	self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		
def setVSA(self,buttonFocusP,buttonFocusG,buttonPHover,buttonGHover,boxDone,buttonHoverB, buttonHoverG):
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	typeIdx = self.ui.vsaType.currentIndex()
	
	# if all top vsa parameters are filled out
	if averaging != 0 and demod != 0:
		# set new activated buttons
		if typeIdx == 1 or typeIdx == 2 or typeIdx == 3 or typeIdx == 4:
			self.ui.meterButton_vsa.setStyleSheet(buttonHoverB)
			self.ui.meterButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
		elif typeIdx == 5 or typeIdx == 6:
			self.ui.downButton_vsa.setStyleSheet(buttonHoverG)
			self.ui.downButton_vsa_2.setStyleSheet(buttonHoverG)
			self.ui.downButton_vsa.setCursor(QCursor(Qt.PointingHandCursor))
			self.ui.downButton_vsa_2.setCursor(QCursor(Qt.PointingHandCursor))
		
		# style mod related widgets
		if typeIdx == 3 or typeIdx == 4: # UXA & PXA
			self.ui.uxaEquipGeneralVSA.setStyleSheet(boxDone)
			demod = self.ui.uxaMod.isEnabled()
			if demod:
				setAllDemod(self, boxDone)
				self.ui.modButton_vsa.setStyleSheet(buttonFocusG)
			self.ui.vsaNextStack.setCurrentIndex(3)
			self.ui.vsgNextSteps.setCurrentIndex(7)
			self.ui.up_psg_next.setCurrentIndex(5)
		elif typeIdx == 1 or typeIdx == 2 or typeIdx == 5 or typeIdx == 6:
			demodScope = self.ui.scopeMod.isEnabled()
			demodDig = self.ui.digMod.isEnabled()
			if demodScope or demodDig:
				setAllDemod(self, boxDone)
				self.ui.modButton_vsa_2.setStyleSheet(buttonFocusG)
				self.ui.modButton_vsa.setStyleSheet(buttonFocusG)
			
		if typeIdx == 3: #UXA
			self.ui.uxaButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.uxaButton_vsa_2.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover,buttonGHover,buttonHoverG)
			setFocusAndHand(self,self.ui.meterButton_vsa,buttonHoverB)
			setFocusAndHand(self,self.ui.meterButton_up,buttonHoverB)
			setFocusAndHand(self,self.ui.meterButton_vsg,buttonHoverB)
		elif typeIdx == 4: #PXA
			self.ui.pxaButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.pxaButton_vsa_2.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover,buttonGHover,buttonHoverG)		
			setFocusAndHand(self,self.ui.meterButton_vsa,buttonHoverB)
			setFocusAndHand(self,self.ui.meterButton_up,buttonHoverB)
			setFocusAndHand(self,self.ui.meterButton_vsg,buttonHoverB)
		elif typeIdx == 1 or typeIdx == 5: #Scope
			self.ui.scopeEquipGeneral.setStyleSheet(boxDone)
			self.ui.scopeButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.scopeButton_vsa_2.setStyleSheet(buttonFocusP)
			self.ui.scopeButton_vsa_3.setStyleSheet(buttonFocusP)
			self.ui.scopeButton_vsa_4.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover,buttonGHover,buttonHoverG)
			if typeIdx == 1:
				self.ui.vsaNextStack.setCurrentIndex(3)
				self.ui.vsgNextSteps.setCurrentIndex(7)
				self.ui.up_psg_next.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.meterButton_vsa,buttonHoverB)
				setFocusAndHand(self,self.ui.meterButton_up,buttonHoverB)
				setFocusAndHand(self,self.ui.meterButton_vsg,buttonHoverB)
			elif typeIdx == 5:
				self.ui.vsaNextStack.setCurrentIndex(2)
				self.ui.vsgNextSteps.setCurrentIndex(6)
				self.ui.up_psg_next.setCurrentIndex(4)
		elif typeIdx == 2 or typeIdx ==6: #Digitizer
			self.ui.digEquipGeneral.setStyleSheet(boxDone)
			self.ui.digButton_vsa.setStyleSheet(buttonFocusP)
			self.ui.digButton_vsa_2.setStyleSheet(buttonFocusP)
			self.ui.digButton_vsa_3.setStyleSheet(buttonFocusP)
			self.ui.digButton_vsa_4.setStyleSheet(buttonFocusP)
			setPrevVSAButtons(self,buttonPHover,buttonGHover,buttonHoverG)
			if typeIdx == 2:
				self.ui.vsaNextStack.setCurrentIndex(3)
				self.ui.vsgNextSteps.setCurrentIndex(7)
				self.ui.up_psg_next.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.meterButton_vsa,buttonHoverB)
				setFocusAndHand(self,self.ui.meterButton_up,buttonHoverB)
				setFocusAndHand(self,self.ui.meterButton_vsg,buttonHoverB)
			elif typeIdx == 6:
				self.ui.vsaNextStack.setCurrentIndex(2)
				self.ui.vsgNextSteps.setCurrentIndex(6)
				self.ui.up_psg_next.setCurrentIndex(4)
	else:
		self.fillParametersMsg()
		self.ui.digSet.setChecked(False)
		self.ui.scopeSet.setChecked(False)
		self.ui.uxaSet.setChecked(False)
		
def setVSAAdv(self,boxDone):
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	if averaging != 0 and demod != 0:
		self.ui.uxaVSAAdv.setStyleSheet(boxDone)
		self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)
	else:
		self.fillParametersMsg()
		self.ui.uxaVSASetAdv.setChecked(False)

def setDown(self,buttonColourFocus,buttonHoverB,buttonGHover,boxDone):
	self.ui.downButton_down.setStyleSheet(buttonColourFocus)
	self.ui.downButton_down_2.setStyleSheet(buttonColourFocus)
	self.ui.downEquip.setStyleSheet(boxDone)
	
	setPrevDownButtons(self,buttonGHover,buttonHoverB)
	self.ui.downNextStack.setCurrentIndex(1)
	self.ui.vsaNextStack.setCurrentIndex(3)
	self.ui.up_psg_next.setCurrentIndex(5)
	self.ui.vsgNextSteps.setCurrentIndex(7)
	
def setMeter(self,buttonColourFocus,buttonBHover,buttonHoverP,boxDone):
	self.ui.meterButton_meter.setStyleSheet(buttonColourFocus)
	setPrevMeterButtons(self,buttonBHover,buttonHoverP)
	self.ui.meterEquip.setStyleSheet(boxDone)
	
	self.ui.meterNextStack.setCurrentIndex(1)
	self.ui.downNextStack.setCurrentIndex(2)
	self.ui.vsaNextStack.setCurrentIndex(4)
	self.ui.up_psg_next.setCurrentIndex(6)
	self.ui.vsgNextSteps.setCurrentIndex(8)
	
def setSA(self,buttonColourFocus,buttonPHover,buttonHoverB,boxDone):
	self.ui.saButton_sa.setStyleSheet(buttonColourFocus)
	self.ui.saButton_sa_2.setStyleSheet(buttonColourFocus)
	self.ui.saButton_sa_3.setStyleSheet(buttonColourFocus)
	self.ui.saButton_sa_4.setStyleSheet(buttonColourFocus)
	setPrevSAButtons(self,buttonPHover,buttonHoverB)
	self.ui.saEquip.setStyleSheet(boxDone)
	
	self.ui.saNextStack.setCurrentIndex(0)
	self.ui.meterNextStack.setCurrentIndex(2)
	self.ui.downNextStack.setCurrentIndex(3)
	self.ui.vsaNextStack.setCurrentIndex(5)
	self.ui.up_psg_next.setCurrentIndex(7)
	self.ui.vsgNextSteps.setCurrentIndex(9)
		
def setP1(self,boxDone,buttonFocus,buttonBHover,buttonHoverB,greyButtonB):
	c1Checked = self.ui.p1c1Check.isChecked()
	c2Checked = self.ui.p1c2Check.isChecked()
	c3Checked = self.ui.p1c3Check.isChecked()
	c4Checked = self.ui.p1c4Check.isChecked()
	vsgType = self.ui.vsgSetup.currentIndex()
	vsaType = self.ui.vsaType.currentIndex()
	
	self.ui.p1Equip.setStyleSheet(boxDone)
	if c1Checked:
		self.ui.p1c1Equip.setStyleSheet(boxDone)
	if c2Checked:
		self.ui.p1c2Equip.setStyleSheet(boxDone)
	if c3Checked:
		self.ui.p1c3Equip.setStyleSheet(boxDone)
	if c4Checked:
		self.ui.p1c4Equip.setStyleSheet(boxDone)
	self.ui.power1Button_p1.setStyleSheet(buttonFocus)
	
	if vsgType == 1 or vsgType == 4:
		if vsaType == 1 or vsaType == 2 or vsaType == 3 or vsaType == 4:
			self.ui.power1NextStack.setCurrentIndex(3)
			self.ui.saNextStack.setCurrentIndex(3)
			self.ui.meterNextStack.setCurrentIndex(5)
			self.ui.downNextStack.setCurrentIndex(6)
			self.ui.vsaNextStack.setCurrentIndex(8)
			self.ui.up_psg_next.setCurrentIndex(10)
			self.ui.vsgNextSteps.setCurrentIndex(12)
			setPrevP1Buttons(self,buttonBHover,greyButtonB,greyButtonB)
		elif vsaType == 5 or vsaType ==6:
			self.ui.power1NextStack.setCurrentIndex(2)
			self.ui.saNextStack.setCurrentIndex(2)
			self.ui.meterNextStack.setCurrentIndex(4)
			self.ui.downNextStack.setCurrentIndex(5)
			self.ui.vsaNextStack.setCurrentIndex(7)
			self.ui.up_psg_next.setCurrentIndex(9)
			self.ui.vsgNextSteps.setCurrentIndex(11)
			setPrevP1Buttons(self,buttonBHover,greyButtonB,buttonHoverB)
	elif vsgType == 2 or vsgType == 3:
		self.ui.power1NextStack.setCurrentIndex(1)
		self.ui.saNextStack.setCurrentIndex(1)
		self.ui.meterNextStack.setCurrentIndex(3)
		self.ui.downNextStack.setCurrentIndex(4)
		self.ui.vsaNextStack.setCurrentIndex(6)
		self.ui.up_psg_next.setCurrentIndex(8)
		self.ui.vsgNextSteps.setCurrentIndex(10)
		setPrevP1Buttons(self,buttonBHover,buttonHoverB,greyButtonB)

def setP2(self):
	c1Checked = self.ui.p2c1Check.isChecked()
	c2Checked = self.ui.p2c2Check.isChecked()
	c3Checked = self.ui.p2c3Check.isChecked()
	c4Checked = self.ui.p2c4Check.isChecked()
	vsaType = self.ui.vsaType.currentIndex()
	
	self.ui.p2Equip.setStyleSheet(boxDone)
	if c1Checked:
		self.ui.p2c1Equip.setStyleSheet(boxDone)
	if c2Checked:
		self.ui.p2c2Equip.setStyleSheet(boxDone)
	if c3Checked:
		self.ui.p2c3Equip.setStyleSheet(boxDone)
	if c4Checked:
		self.ui.p2c4Equip.setStyleSheet(boxDone)
	self.ui.power2Button_p2.setStyleSheet(buttonFocus)
	
	if vsaType == 1 or vsaType == 2 or vsaType == 3 or vsaType == 4:
		self.ui.power2NextStack.setCurrentIndex()
		self.ui.power1NextStack.setCurrentIndex(3)
		self.ui.saNextStack.setCurrentIndex(3)
		self.ui.meterNextStack.setCurrentIndex(5)
		self.ui.downNextStack.setCurrentIndex(6)
		self.ui.vsaNextStack.setCurrentIndex(8)
		self.ui.up_psg_next.setCurrentIndex(10)
		self.ui.vsgNextSteps.setCurrentIndex(12)
		setPrevP1Buttons(self,buttonBHover,greyButtonB,greyButtonB)
	elif vsaType == 5 or vsaType ==6:
		self.ui.power2NextStack.setCurrentIndex()
		self.ui.power1NextStack.setCurrentIndex(2)
		self.ui.saNextStack.setCurrentIndex(2)
		self.ui.meterNextStack.setCurrentIndex(4)
		self.ui.downNextStack.setCurrentIndex(5)
		self.ui.vsaNextStack.setCurrentIndex(7)
		self.ui.up_psg_next.setCurrentIndex(9)
		self.ui.vsgNextSteps.setCurrentIndex(11)
		setPrevP1Buttons(self,buttonBHover,greyButtonB,buttonHoverB)
	
def setP3(self):
	c1Checked = self.ui.p2c1Check.isChecked()
	c2Checked = self.ui.p2c2Check.isChecked()
	c3Checked = self.ui.p2c3Check.isChecked()
	c4Checked = self.ui.p2c4Check.isChecked()
	if c1Checked:
		self.ui.p3c1Equip.setStyleSheet(boxDone)
	if c2Checked:
		self.ui.p3c2Equip.setStyleSheet(boxDone)
	if c3Checked:
		self.ui.p3c3Equip.setStyleSheet(boxDone)
	if c4Checked:
		self.ui.p3c4Equip.setStyleSheet(boxDone)
	self.ui.power3Button_p3.setStyleSheet(buttonFocus)
	self.ui.power3Button_p3_2.setStyleSheet(buttonFocus)
	
		
def rxCalRoutine(self):
	self.resize(1265,950)
	self.center()
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

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions for setParameters.py	

def setPrevVSAButtons(self,buttonPHover,buttonGHover,buttonHoverG):
	setFocusAndHand(self,self.ui.vsaButton_up,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_up,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_up_2,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_up_3,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_up_4,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_up,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_up_2,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_up_3,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_up_4,buttonPHover)
	setFocusAndHand(self,self.ui.uxaButton_up,buttonPHover)
	setFocusAndHand(self,self.ui.uxaButton_up_2,buttonPHover)
	setFocusAndHand(self,self.ui.pxaButton_up,buttonPHover)
	setFocusAndHand(self,self.ui.pxaButton_up_2,buttonPHover)
	setFocusAndHand(self,self.ui.modButton_up,buttonGHover)
	setFocusAndHand(self,self.ui.modButton_up_2,buttonGHover)
	setFocusAndHand(self,self.ui.vsaButton_vsg,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg_2,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg_3,buttonPHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg_4,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_vsg,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_vsg_2,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_vsg_3,buttonPHover)
	setFocusAndHand(self,self.ui.digButton_vsg_4,buttonPHover)
	setFocusAndHand(self,self.ui.uxaButton_vsg,buttonPHover)
	setFocusAndHand(self,self.ui.uxaButton_vsg_2,buttonPHover)
	setFocusAndHand(self,self.ui.pxaButton_vsg,buttonPHover)
	setFocusAndHand(self,self.ui.pxaButton_vsg_2,buttonPHover)
	setFocusAndHand(self,self.ui.modButton_vsg,buttonGHover)
	setFocusAndHand(self,self.ui.modButton_vsg_2,buttonGHover)
	setFocusAndHand(self,self.ui.downButton_vsa,buttonHoverG)
	setFocusAndHand(self,self.ui.downButton_vsa_2,buttonHoverG)
	setFocusAndHand(self,self.ui.downButton_up,buttonHoverG)
	setFocusAndHand(self,self.ui.downButton_up_2,buttonHoverG)
	setFocusAndHand(self,self.ui.downButton_vsg,buttonHoverG)
	setFocusAndHand(self,self.ui.downButton_vsg_2,buttonHoverG)
	
def setPrevDownButtons(self,buttonGHover,buttonHoverB):
	setFocusAndHand(self,self.ui.downButton_vsa,buttonGHover)
	setFocusAndHand(self,self.ui.downButton_vsa_2,buttonGHover)
	setFocusAndHand(self,self.ui.downButton_up,buttonGHover)
	setFocusAndHand(self,self.ui.downButton_up_2,buttonGHover)
	setFocusAndHand(self,self.ui.downButton_vsg,buttonGHover)
	setFocusAndHand(self,self.ui.downButton_vsg_2,buttonGHover)
	setFocusAndHand(self,self.ui.meterButton_down,buttonHoverB)
	setFocusAndHand(self,self.ui.meterButton_vsa,buttonHoverB)
	setFocusAndHand(self,self.ui.meterButton_up,buttonHoverB)
	setFocusAndHand(self,self.ui.meterButton_vsg,buttonHoverB)
	
def setPrevMeterButtons(self,buttonBHover,buttonHoverP):
	setFocusAndHand(self,self.ui.meterButton_down,buttonBHover)
	setFocusAndHand(self,self.ui.meterButton_vsa,buttonBHover)
	setFocusAndHand(self,self.ui.meterButton_up,buttonBHover)
	setFocusAndHand(self,self.ui.meterButton_vsg,buttonBHover)
	setFocusAndHand(self,self.ui.saButton_vsg,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsg_2,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsg_3,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsg_4,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsg_5,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_up,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_up_2,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_up_3,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_up_4,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_up_5,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsa,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsa_2,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsa_3,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsa_4,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_vsa_5,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_down,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_down_2,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_meter,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_meter_2,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_meter_3,buttonHoverP)
	setFocusAndHand(self,self.ui.saButton_meter_4,buttonHoverP)

def	setPrevSAButtons(self,buttonPHover,buttonHoverB):
	setFocusAndHand(self,self.ui.saButton_vsg,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsg_2,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsg_3,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsg_4,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsg_5,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_up,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_up_2,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_up_3,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_up_4,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_up_5,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsa,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsa_2,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsa_3,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsa_4,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_vsa_5,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_down,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_down_2,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_meter,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_meter_2,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_meter_3,buttonPHover)
	setFocusAndHand(self,self.ui.saButton_meter_4,buttonPHover)
	setFocusAndHand(self,self.ui.power1Button_sa,buttonHoverB)
	setFocusAndHand(self,self.ui.power1Button_meter,buttonHoverB)
	setFocusAndHand(self,self.ui.power1Button_down,buttonHoverB)
	setFocusAndHand(self,self.ui.power1Button_vsa,buttonHoverB)
	setFocusAndHand(self,self.ui.power1Button_up,buttonHoverB)
	setFocusAndHand(self,self.ui.power1Button_vsg,buttonHoverB)
	
def setPrevP1Buttons(self,buttonColourOne,buttonColourTwo,buttonColourThree):
	setFocusAndHand(self,self.ui.power1Button_sa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_meter,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_down,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_up,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsg,buttonColourOne)
	setFocusAndHand(self,self.ui.power2Button_p1,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_p1_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_sa,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_sa_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_meter_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_meter,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_down,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_down_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_vsa,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_vsa_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_up,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_vsg,buttonColourTwo)
	setFocusAndHand(self,self.ui.power2Button_vsg_2,buttonColourTwo)
	setFocusAndHand(self,self.ui.power3Button_p1,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_p1_2,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_sa,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_sa_2,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_meter_2,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_meter,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_down,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_down_2,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_vsa,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_vsa_2,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_up,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_up_2,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_vsg,buttonColourThree)
	setFocusAndHand(self,self.ui.power3Button_vsg_2,buttonColourThree)

def setFocusAndHand(self,button,colour):
	button.setStyleSheet(colour)
	button.setCursor(QCursor(Qt.PointingHandCursor))

def setAllDemod(self, boxDone):
	self.ui.digMod.setStyleSheet(boxDone)
	self.ui.scopeMod.setStyleSheet(boxDone)
	self.ui.uxaMod.setStyleSheet(boxDone)
	
def setStandardMessage(self):
	self.ui.statusBar.showMessage('Successfully Set Standard Settings',2000)
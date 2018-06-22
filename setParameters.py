# setParameters.py contains all the functions that are called whenever a "set" "set & run" or "preview" button is clicked

from PyQt5.QtWidgets import (QProgressBar)
from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)
#import matlab.engine
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions used in main.py

def setGeneralAWG(self,buttonFocus,boxDone,greyHover):
	self.ui.awgButton_vsg.setStyleSheet(buttonFocus)
	self.ui.awgButton_vsg_2.setStyleSheet(buttonFocus)
	self.ui.awgButton_vsg_3.setStyleSheet(buttonFocus)
	setStandardMessage(self)
	self.ui.awgEquipGeneral.setStyleSheet(boxDone)
	setupIdx = self.ui.vsgWorkflows.currentIndex()
	if setupIdx == 1:
		self.ui.vsgNextSteps.setCurrentIndex(5)
		self.ui.vsaButton_vsg.setStyleSheet(greyHover)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	elif setupIdx == 2:
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
		
def setGeneralVSG(self,buttonFocus,boxDone,greyHover):
	self.ui.vsgButton_vsg.setStyleSheet(buttonFocus)
	self.ui.vsgEquipGeneral.setStyleSheet(boxDone)
	setStandardMessage(self)
	self.ui.vsgNextSteps.setCurrentIndex(5)
	self.ui.vsaButton_vsg.setStyleSheet(greyHover)
	self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))

def setAdvanced(self,box,boxDone):
	box.setStyleSheet(boxDone)
	self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)

def setUp(self,buttonFocus,buttonDone,boxDone,greyHover):
	self.ui.upButton_up.setStyleSheet(buttonFocus)
	self.ui.upButton_vsg.setStyleSheet(buttonDone)
	self.ui.upEquip.setStyleSheet(boxDone)
	self.ui.up_psg_next.setCurrentIndex(2)
	self.ui.vsgNextSteps.setCurrentIndex(5)
	setStandardMessage(self)
	self.ui.vsaButton_up.setStyleSheet(greyHover)
	self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
	self.ui.vsaButton_vsg.setStyleSheet(greyHover)
	self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))

def setPSG(self,buttonFocus,buttonDone,boxDone,greyHover):
	self.ui.psgButton_up.setStyleSheet(buttonFocus)
	self.ui.psgButton_vsg.setStyleSheet(buttonDone)
	self.ui.psgEquip.setStyleSheet(boxDone)
	self.ui.up_psg_next.setCurrentIndex(2)
	self.ui.vsgNextSteps.setCurrentIndex(5)
	setStandardMessage(self)
	self.ui.vsaButton_up.setStyleSheet(greyHover)
	self.ui.vsaButton_up.setCursor(QCursor(Qt.PointingHandCursor))
	self.ui.vsaButton_vsg.setStyleSheet(greyHover)
	self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		
def setVSA(self,buttonFocus,setButtonHover,boxDone,greyHover):
	averaging = self.ui.averagingEnable.currentIndex()
	demod = self.ui.demodulationEnable.currentIndex()
	typeIdx = self.ui.vsaType.currentIndex()
	
	# if all top vsa parameters are filled out
	if averaging != 0 and demod != 0:
		# set new activated buttons
		if typeIdx == 1 or typeIdx == 2 or typeIdx == 3 or typeIdx == 4:
			setFocusAndHand(self,self.ui.meterButton_vsa,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_2,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_3,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_4,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_5,greyHover)
		elif typeIdx == 5 or typeIdx == 6:
			setFocusAndHand(self,self.ui.downButton_vsa,greyHover)
			setFocusAndHand(self,self.ui.downButton_vsa_2,greyHover)
		
		# style mod related widgets
		if typeIdx == 3 or typeIdx == 4: # UXA & PXA
			self.ui.uxaEquipGeneralVSA.setStyleSheet(boxDone)
			demod = self.ui.uxaMod.isEnabled()
			if demod:
				setAllDemod(self,boxDone)
				self.ui.modButton_vsa.setStyleSheet(buttonFocus)
			self.ui.vsaNextStack.setCurrentIndex(3)
			self.ui.vsgNextSteps.setCurrentIndex(7)
			self.ui.up_psg_next.setCurrentIndex(5)
		elif typeIdx == 1 or typeIdx == 2 or typeIdx == 5 or typeIdx == 6:
			demodScope = self.ui.scopeMod.isEnabled()
			demodDig = self.ui.digMod.isEnabled()
			if demodScope or demodDig:
				setAllDemod(self,boxDone)
				self.ui.modButton_vsa_2.setStyleSheet(buttonFocus)
				self.ui.modButton_vsa.setStyleSheet(buttonFocus)
			
		if typeIdx == 3: #UXA
			self.ui.uxaButton_vsa.setStyleSheet(buttonFocus)
			self.ui.uxaButton_vsa_2.setStyleSheet(buttonFocus)
			setPrevVSAButtons(self,setButtonHover,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_2,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_3,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_4,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_5,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_2,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_3,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_4,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_5,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_2,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_3,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_4,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_5,greyHover)
		elif typeIdx == 4: #PXA
			self.ui.pxaButton_vsa.setStyleSheet(buttonFocus)
			self.ui.pxaButton_vsa_2.setStyleSheet(buttonFocus)
			setPrevVSAButtons(self,setButtonHover,greyHover)		
			setFocusAndHand(self,self.ui.meterButton_vsa,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_2,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_3,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_4,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsa_5,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_2,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_3,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_4,greyHover)
			setFocusAndHand(self,self.ui.meterButton_up_5,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_2,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_3,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_4,greyHover)
			setFocusAndHand(self,self.ui.meterButton_vsg_5,greyHover)
		elif typeIdx == 1 or typeIdx == 5: #Scope
			self.ui.scopeEquipGeneral.setStyleSheet(boxDone)
			self.ui.scopeButton_vsa.setStyleSheet(buttonFocus)
			self.ui.scopeButton_vsa_2.setStyleSheet(buttonFocus)
			self.ui.scopeButton_vsa_3.setStyleSheet(buttonFocus)
			self.ui.scopeButton_vsa_4.setStyleSheet(buttonFocus)
			setPrevVSAButtons(self,setButtonHover,greyHover)
			if typeIdx == 1:
				self.ui.vsaNextStack.setCurrentIndex(3)
				self.ui.vsgNextSteps.setCurrentIndex(7)
				self.ui.up_psg_next.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.meterButton_vsa,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_2,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_3,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_4,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_5,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_2,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_3,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_4,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_5,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_2,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_3,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_4,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_5,greyHover)
			elif typeIdx == 5:
				self.ui.vsaNextStack.setCurrentIndex(2)
				self.ui.vsgNextSteps.setCurrentIndex(6)
				self.ui.up_psg_next.setCurrentIndex(4)
		elif typeIdx == 2 or typeIdx ==6: #Digitizer
			self.ui.digEquipGeneral.setStyleSheet(boxDone)
			self.ui.digButton_vsa.setStyleSheet(buttonFocus)
			self.ui.digButton_vsa_2.setStyleSheet(buttonFocus)
			self.ui.digButton_vsa_3.setStyleSheet(buttonFocus)
			self.ui.digButton_vsa_4.setStyleSheet(buttonFocus)
			setPrevVSAButtons(self,setButtonHover,greyHover)
			if typeIdx == 2:
				self.ui.vsaNextStack.setCurrentIndex(3)
				self.ui.vsgNextSteps.setCurrentIndex(7)
				self.ui.up_psg_next.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.meterButton_vsa,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_2,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_3,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_4,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsa_5,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_2,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_3,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_4,greyHover)
				setFocusAndHand(self,self.ui.meterButton_up_5,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_2,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_3,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_4,greyHover)
				setFocusAndHand(self,self.ui.meterButton_vsg_5,greyHover)
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

def setDown(self,buttonFocus,greyHover,buttonHover,boxDone):
	#meterChecked = self.ui.meterSet.isChecked()
	
	self.ui.downButton_down.setStyleSheet(buttonFocus)
	self.ui.downButton_down_2.setStyleSheet(buttonFocus)
	self.ui.downEquip.setStyleSheet(boxDone)
	
	setPrevDownButtons(self,buttonHover,greyHover)
	#if meterChecked:
	#	self.ui.downNextStack.setCurrentIndex(2)
	#else:
	self.ui.downNextStack.setCurrentIndex(1)
	self.ui.vsaNextStack.setCurrentIndex(3)
	self.ui.up_psg_next.setCurrentIndex(5)
	self.ui.vsgNextSteps.setCurrentIndex(7)
	
def setMeter(self,buttonFocus,buttonHover,greyHover,boxDone):
	self.ui.meterButton_meter.setStyleSheet(buttonFocus)
	self.ui.meterButton_meter_2.setStyleSheet(buttonFocus)
	self.ui.meterButton_meter_3.setStyleSheet(buttonFocus)
	self.ui.meterButton_meter_4.setStyleSheet(buttonFocus)
	setPrevMeterButtons(self,buttonHover,greyHover)
	self.ui.meterEquip.setStyleSheet(boxDone)
	
	self.ui.meterNextStack.setCurrentIndex(1)
	self.ui.downNextStack.setCurrentIndex(2)
	self.ui.vsaNextStack.setCurrentIndex(4)
	self.ui.up_psg_next.setCurrentIndex(6)
	self.ui.vsgNextSteps.setCurrentIndex(8)
	
def setSA(self,buttonFocus,buttonPHover,buttonHover,boxDone):
	self.ui.saButton_sa.setStyleSheet(buttonFocus)
	self.ui.saButton_sa_2.setStyleSheet(buttonFocus)
	self.ui.saButton_sa_3.setStyleSheet(buttonFocus)
	self.ui.saButton_sa_4.setStyleSheet(buttonFocus)
	setPrevSAButtons(self,buttonPHover,buttonHover)
	self.ui.saEquip.setStyleSheet(boxDone)
	
	self.ui.saNextStack.setCurrentIndex(0)
	self.ui.meterNextStack.setCurrentIndex(2)
	self.ui.downNextStack.setCurrentIndex(3)
	self.ui.vsaNextStack.setCurrentIndex(5)
	self.ui.up_psg_next.setCurrentIndex(7)
	self.ui.vsgNextSteps.setCurrentIndex(9)
		
def setP1(self,boxDone,buttonFocus,buttonHover,greyHover,greyButton):
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
		
	# get field data
	p1c1V = self.ui.p1c1Voltage.toPlainText()
	# eng = matlab.engine.start_matlab()
	# eng.Set_Voltage(p1c1V,nargout=0)
	

def setP2(self,boxDone,buttonFocus,buttonHover,greyHoverB,greyButton):
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
		setPrevP2Buttons(self,buttonHover,greyHoverB)
	
def setP3(self,boxDone,buttonFocus,buttonHover):
	c1Checked = self.ui.p3c1Check.isChecked()
	c2Checked = self.ui.p3c2Check.isChecked()
	c3Checked = self.ui.p3c3Check.isChecked()
	c4Checked = self.ui.p3c4Check.isChecked()
	if c1Checked:
		self.ui.p3c1Equip.setStyleSheet(boxDone)
	if c2Checked:
		self.ui.p3c2Equip.setStyleSheet(boxDone)
	if c3Checked:
		self.ui.p3c3Equip.setStyleSheet(boxDone)
	if c4Checked:
		self.ui.p3c4Equip.setStyleSheet(boxDone)
	self.ui.p3Equip.setStyleSheet(boxDone)
	
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

def setVSAMeasDig(self,boxDone,buttonPHover):
	vsaType = self.ui.vsaWorkflow_vsaMeas.currentIndex()
	vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
	self.ui.vsaMeasGenEquip.setStyleSheet(boxDone)
	self.ui.vsaMeasGenEquip_2.setStyleSheet(boxDone)
	self.ui.vsaMeasDigEquip.setStyleSheet(boxDone)
	self.ui.digMark_vsaMeas.setVisible(True)
	self.ui.digMark_vsaMeas_2.setVisible(True)
	if vsaType == 0:
		if vsgType == 3: # vsg
			self.ui.vsaMeasNextStack.setCurrentIndex(6)
			setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonPHover)
		else:
			self.ui.vsaMeasNextStack.setCurrentIndex(5)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonPHover)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonPHover)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonPHover)
	elif vsaType == 1: # has down
		self.ui.vsaMeasNextStack.setCurrentIndex(1)
	
def setVSAMeasGen(self,boxDone,buttonPHover):
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
		elif downType == 0: # dig
			self.ui.digMark_vsaMeas.setVisible(True)
			self.ui.digMark_vsaMeas_2.setVisible(True)
	elif vsaType == 0:
		if analyzerType == 1: # scope
			self.ui.scopeMark_vsaMeas.setVisible(True)
			self.ui.scopeMark_vsaMeas_2.setVisible(True)
		elif analyzerType == 2: # dig
			self.ui.digMark_vsaMeas.setVisible(True)
			self.ui.digMark_vsaMeas_2.setVisible(True)
		elif analyzerType == 3: # uxa
			self.ui.uxaMark_vsaMeas.setVisible(True)
		elif analyzerType == 4: # pxa
			self.ui.pxaMark_vsaMeas.setVisible(True)
		if vsgType == 3: # vsg
			self.ui.vsaMeasNextStack.setCurrentIndex(6)
			setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonPHover)
		else:
			self.ui.vsaMeasNextStack.setCurrentIndex(5)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonPHover)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonPHover)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonPHover)
	self.ui.vsaMeasNextStack.setCurrentIndex(1)
	

def setVSAMeasAdv(self,boxDone):
	self.ui.vsaMeasAdvEquip.setStyleSheet(boxDone)
	self.ui.saMark_vsaMeas.setVisible(True)
	self.ui.saMark_vsaMeas_2.setVisible(True)
	self.ui.saMark_vsgMeas.setVisible(True)
	self.ui.saMark_vsgMeas_2.setVisible(True)
	
def rxCalRoutine(self,boxDone,buttonPHover):
	vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
	if vsgType == 3: # vsg
		self.ui.vsaMeasNextStack.setCurrentIndex(6)
		setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonPHover)
	else:
		self.ui.vsaMeasNextStack.setCurrentIndex(5)
		setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonPHover)
		setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonPHover)
		setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonPHover)
	self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
	self.ui.downEquip_vsaMeas.setStyleSheet(boxDone)
	self.ui.rxEquip_vsaMeas.setStyleSheet(boxDone)
	self.ui.vsaResultsStack_vsaMeas.setCurrentIndex(0)
	self.ui.vsaResultsStack_vsgMeas.setCurrentIndex(0)
	self.ui.debugVSAStack.setCurrentIndex(0)
	self.ui.downMark_vsaMeas.setVisible(True)
	self.ui.downMark_vsgMeas.setVisible(True)
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
	
def noRXCalRoutine(self,boxDone,buttonPHover):
	vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
	self.ui.combEquip_vsaMeas.setStyleSheet(boxDone)
	self.ui.downEquip_vsaMeas.setStyleSheet(boxDone)
	self.ui.rxEquip_vsaMeas.setStyleSheet(boxDone)
	self.ui.vsaResultsStack_vsaMeas.setCurrentIndex(0)
	self.ui.vsaResultsStack_vsgMeas.setCurrentIndex(0)
	self.ui.downMark_vsaMeas.setVisible(True)
	self.ui.downMark_vsgMeas.setVisible(True)
	if vsgType == 3: # vsg
		self.ui.vsaMeasNextStack.setCurrentIndex(6)
		setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonPHover)
	else:
		self.ui.vsaMeasNextStack.setCurrentIndex(5)
		setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonPHover)
		setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonPHover)
		setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonPHover)

def awgCalRoutine(self,boxDone):
	self.ui.awgEquip_vsgMeas.setStyleSheet(boxDone)
	self.ui.rxEquip_vsgMeas.setStyleSheet(boxDone)
	self.ui.vsgEquip_vsgMeas.setStyleSheet(boxDone)
	self.ui.calEquip_vsgMeas.setStyleSheet(boxDone)
	self.ui.awgCalEquip_vsgMeas.setStyleSheet(boxDone)
	self.ui.vsgMeasNextStack.setCurrentIndex(5)
	self.ui.debugVSGStack.setCurrentIndex(0)
	self.ui.vsgResultsFileStack_vsgMeas.setCurrentIndex(1)
	self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
	
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

def noAWGCalRoutine(self,boxDone):
	self.ui.awgEquip_vsgMeas_2.setStyleSheet(boxDone)
	self.ui.awgCalEquip_vsgMeas_2.setStyleSheet(boxDone)
	self.ui.vsgMeasNextStack.setCurrentIndex(5)
	
def setAdvVSGMeas(self,boxDone):
	awgOnly = self.ui.setAdv_vsgMeas.isChecked()
	awgAndVSA = self.ui.setAdv_vsgMeas_2.isChecked()
	if awgOnly:
		self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(boxDone)
		self.ui.awgAdvEquip_vsgMeas.setStyleSheet(boxDone)
	if awgAndVSA:
		self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(boxDone)
		self.ui.awgAdvEquip_vsgMeas.setStyleSheet(boxDone)
		self.ui.vsaAdvEquip_vsgMeas.setStyleSheet(boxDone)
		
def awgPreview(self):
	self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
	self.ui.resultsTabs_vsgMeas.setCurrentIndex(1)
	
def setUpVSGMeas(self,boxDone):
	awgChecked = self.ui.awgSet_vsgMeas.isChecked()
	awgRunChecked = self.ui.awgSetRun_vsgMeas.isChecked()
	if awgChecked or awgRunChecked:
		self.ui.upCalHomoEquip_vsgMeas.setStyleSheet(boxDone)
		self.ui.upCalHeteroEquip_vsgMeas.setStyleSheet(boxDone)
		self.ui.upEquip_vsgMeas.setStyleSheet(boxDone)
		self.ui.vsgMeasNextStack.setCurrentIndex(8)
		
def setHetero(self,boxDone):
	self.ui.calEquip_hetero.setStyleSheet(boxDone)
	self.ui.rxEquip_hetero.setStyleSheet(boxDone)
	self.ui.vsgEquip_hetero.setStyleSheet(boxDone)
	self.ui.upCalEquipHomo_hetero.setStyleSheet(boxDone)
	self.ui.upCalEquipHetero_hetero.setStyleSheet(boxDone)
	self.ui.upEquip_hetero.setStyleSheet(boxDone)
	self.ui.vsgMeasNextStack.setCurrentIndex(8)
	self.ui.vsgResultsFileStack_vsgMeas.setCurrentIndex(1)
	self.ui.debugVSGStack.setCurrentIndex(0)
	self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
	
	self.progressBar = QProgressBar()
	self.progressBar.setRange(1,10);
	self.progressBar.setTextVisible(True);
	self.progressBar.setFormat("Currently Running: Heterodyne Calibration Routine")
	self.ui.statusBar.addWidget(self.progressBar,1)
	completed = 0
	while completed < 100:
		completed = completed + 0.00001
		self.progressBar.setValue(completed)
	self.ui.statusBar.removeWidget(self.progressBar)
	# to show progress bar, need both addWidget() and show()
	self.ui.statusBar.showMessage("Heterodyne Calibration Routine Complete",3000)
	
def setHomo(self,boxDone):
	self.ui.calEquip_homo.setStyleSheet(boxDone)
	self.ui.rxEquip_homo.setStyleSheet(boxDone)
	self.ui.vsgEquip_homo.setStyleSheet(boxDone)
	self.ui.upCalEquipHomo_homo.setStyleSheet(boxDone)
	self.ui.upCalEquipHetero_homo.setStyleSheet(boxDone)
	self.ui.upEquip_homo.setStyleSheet(boxDone)
	self.ui.scopeEquip_homo.setStyleSheet(boxDone)
	self.ui.vsgMeasNextStack.setCurrentIndex(8)
	self.ui.debugVSGStack.setCurrentIndex(1)
	self.ui.vsgResultsFileStack_vsgMeas.setCurrentIndex(0)
	self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
	
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
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions for setParameters.py	

def setPrevVSAButtons(self,setButtonHover,greyHover):
	setFocusAndHand(self,self.ui.vsaButton_up,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_up,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_up_2,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_up_3,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_up_4,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_up,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_up_2,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_up_3,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_up_4,setButtonHover)
	setFocusAndHand(self,self.ui.uxaButton_up,setButtonHover)
	setFocusAndHand(self,self.ui.uxaButton_up_2,setButtonHover)
	setFocusAndHand(self,self.ui.pxaButton_up,setButtonHover)
	setFocusAndHand(self,self.ui.pxaButton_up_2,setButtonHover)
	setFocusAndHand(self,self.ui.modButton_up,setButtonHover)
	setFocusAndHand(self,self.ui.modButton_up_2,setButtonHover)
	setFocusAndHand(self,self.ui.vsaButton_vsg,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg_2,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg_3,setButtonHover)
	setFocusAndHand(self,self.ui.scopeButton_vsg_4,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_vsg,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_vsg_2,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_vsg_3,setButtonHover)
	setFocusAndHand(self,self.ui.digButton_vsg_4,setButtonHover)
	setFocusAndHand(self,self.ui.uxaButton_vsg,setButtonHover)
	setFocusAndHand(self,self.ui.uxaButton_vsg_2,setButtonHover)
	setFocusAndHand(self,self.ui.pxaButton_vsg,setButtonHover)
	setFocusAndHand(self,self.ui.pxaButton_vsg_2,setButtonHover)
	setFocusAndHand(self,self.ui.modButton_vsg,setButtonHover)
	setFocusAndHand(self,self.ui.modButton_vsg_2,setButtonHover)
	setFocusAndHand(self,self.ui.downButton_vsa,greyHover)
	setFocusAndHand(self,self.ui.downButton_vsa_2,greyHover)
	setFocusAndHand(self,self.ui.downButton_up,greyHover)
	setFocusAndHand(self,self.ui.downButton_up_2,greyHover)
	setFocusAndHand(self,self.ui.downButton_vsg,greyHover)
	setFocusAndHand(self,self.ui.downButton_vsg_2,greyHover)
	
def setPrevDownButtons(self,buttonHover,greyHover):
	#meterChecked = self.ui.meterSet.isChecked()
	setFocusAndHand(self,self.ui.downButton_vsa,buttonHover)
	setFocusAndHand(self,self.ui.downButton_vsa_2,buttonHover)
	setFocusAndHand(self,self.ui.downButton_up,buttonHover)
	setFocusAndHand(self,self.ui.downButton_up_2,buttonHover)
	setFocusAndHand(self,self.ui.downButton_vsg,buttonHover)
	setFocusAndHand(self,self.ui.downButton_vsg_2,buttonHover)
	#if meterChecked == False:
	setFocusAndHand(self,self.ui.meterButton_down,greyHover)
	setFocusAndHand(self,self.ui.meterButton_down_2,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsa,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_2,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_3,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_4,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_5,greyHover)
	setFocusAndHand(self,self.ui.meterButton_up,greyHover)
	setFocusAndHand(self,self.ui.meterButton_up_2,greyHover)
	setFocusAndHand(self,self.ui.meterButton_up_3,greyHover)
	setFocusAndHand(self,self.ui.meterButton_up_4,greyHover)
	setFocusAndHand(self,self.ui.meterButton_up_5,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsg,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_2,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_3,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_4,greyHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_5,greyHover)
	
def setPrevMeterButtons(self,buttonHover,greyHover):
	setFocusAndHand(self,self.ui.meterButton_down,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_down_2,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsa,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_2,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_3,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_4,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsa_5,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_up,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_up_2,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_up_3,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_up_4,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_up_5,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsg,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_2,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_3,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_4,buttonHover)
	setFocusAndHand(self,self.ui.meterButton_vsg_5,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsg,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsg_2,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsg_3,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsg_4,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsg_5,greyHover)
	setFocusAndHand(self,self.ui.saButton_up,greyHover)
	setFocusAndHand(self,self.ui.saButton_up_2,greyHover)
	setFocusAndHand(self,self.ui.saButton_up_3,greyHover)
	setFocusAndHand(self,self.ui.saButton_up_4,greyHover)
	setFocusAndHand(self,self.ui.saButton_up_5,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsa,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsa_2,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsa_3,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsa_4,greyHover)
	setFocusAndHand(self,self.ui.saButton_vsa_5,greyHover)
	setFocusAndHand(self,self.ui.saButton_down,greyHover)
	setFocusAndHand(self,self.ui.saButton_down_2,greyHover)
	setFocusAndHand(self,self.ui.saButton_meter,greyHover)
	setFocusAndHand(self,self.ui.saButton_meter_2,greyHover)
	setFocusAndHand(self,self.ui.saButton_meter_3,greyHover)
	setFocusAndHand(self,self.ui.saButton_meter_4,greyHover)

def	setPrevSAButtons(self,buttonPHover,buttonHover):
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
	setFocusAndHand(self,self.ui.power1Button_sa,buttonHover)
	setFocusAndHand(self,self.ui.power1Button_meter,buttonHover)
	setFocusAndHand(self,self.ui.power1Button_down,buttonHover)
	setFocusAndHand(self,self.ui.power1Button_vsa,buttonHover)
	setFocusAndHand(self,self.ui.power1Button_up,buttonHover)
	setFocusAndHand(self,self.ui.power1Button_vsg,buttonHover)
	
def setPrevP1Buttons(self,buttonColourOne,buttonColourTwo,buttonColourThree,cursorOne,cursorTwo):
	setFocusAndHand(self,self.ui.power1Button_sa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_meter,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_down,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsa,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_up,buttonColourOne)
	setFocusAndHand(self,self.ui.power1Button_vsg,buttonColourOne)
	
	setFocusAndCursor(self,self.ui.power2Button_p1,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_p1_2,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_sa,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_sa_2,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_meter_2,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_meter,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_down,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_down_2,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_vsa,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_vsa_2,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_up,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_vsg,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power2Button_vsg_2,buttonColourTwo,cursorOne)
	setFocusAndCursor(self,self.ui.power3Button_p1,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_p1_2,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_sa,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_sa_2,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_meter_2,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_meter,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_down,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_down_2,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_vsa,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_vsa_2,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_up,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_up_2,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_vsg,buttonColourThree,cursorTwo)
	setFocusAndCursor(self,self.ui.power3Button_vsg_2,buttonColourThree,cursorTwo)

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

def setFocusAndCursor(self,button,colour,cursor):
	button.setStyleSheet(colour)
	button.setCursor(QCursor(cursor))
	
def setFocusAndHand(self,button,colour):
	button.setStyleSheet(colour)
	button.setCursor(QCursor(Qt.PointingHandCursor))

def setAllDemod(self, boxDone):
	self.ui.digMod.setStyleSheet(boxDone)
	self.ui.scopeMod.setStyleSheet(boxDone)
	self.ui.uxaMod.setStyleSheet(boxDone)
	
def setStandardMessage(self):
	self.ui.statusBar.showMessage('Successfully Set Standard Settings',2000)
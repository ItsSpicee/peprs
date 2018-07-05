# setParameters.py contains all the functions that are called whenever a "set" "set & run" or "preview" button is clicked

from PyQt5.QtWidgets import (QProgressBar,QMessageBox)
from PyQt5.QtGui import (QCursor)
from PyQt5.QtCore import (Qt)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions used in main.py

def setGeneralAWG(self,buttonFocus,boxDone,greyHover, awgSetGeneral):
	
	if awgSetGeneral.isChecked() == True:
		self.ui.awgButton_vsg.setStyleSheet(buttonFocus)
		self.ui.awgButton_vsg_2.setStyleSheet(buttonFocus)
		self.ui.awgButton_vsg_3.setStyleSheet(buttonFocus)
		setStandardMessage(self)
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
	elif  awgSetGeneral.isChecked() == False:
		self.ui.awgEquipGeneral.setStyleSheet(None)
		awgSetGeneral.setText("Set")
		
def setGeneralVSG(self,buttonFocus,boxDone,greyHover,vsgSetGeneral):
	if vsgSetGeneral.isChecked() == True:
		vsgSetGeneral.setText("Unset")
		self.ui.vsgButton_vsg.setStyleSheet(buttonFocus)
		self.ui.vsgEquipGeneral.setStyleSheet(boxDone)
		setStandardMessage(self)
		self.ui.vsgNextSteps.setCurrentIndex(5)
		self.ui.vsaButton_vsg.setStyleSheet(greyHover)
		self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
	elif  vsgSetGeneral.isChecked() == False:
		self.ui.vsgEquipGeneral.setStyleSheet(None)
		vsgSetGeneral.setText("Set")

def setAdvanced(self,box,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
		box.setStyleSheet(boxDone)
		self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)
	elif setButton.isChecked() == False:
		box.setStyleSheet(None)
		setButton.setText("Set")
		
def setUp(self,buttonFocus,buttonDone,boxDone,greyHover,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
	elif setButton.isChecked() == False:
		self.ui.upEquip.setStyleSheet(None)
		setButton.setText("Set")
	

def setPSG(self,buttonFocus,buttonDone,boxDone,greyHover,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
	elif  setButton.isChecked() == False:
		self.ui.psgEquip.setStyleSheet(None)
		setButton.setText("Set")
		
def setVSA(self,buttonFocus,setButtonHover,boxDone,greyHover,setButton):
	averaging = self.ui.averagingEnable.currentIndex()
	avgEnabled = self.ui.averagingEnable.isEnabled()
	demod = self.ui.demodulationEnable.currentIndex()
	typeIdx = self.ui.vsaType.currentIndex()
	
	
	# if all top vsa parameters are filled out
	if averaging != 0 or avgEnabled == False:
		if demod != 0:
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
	if setButton.isChecked() == True:
		averaging = self.ui.averagingEnable.currentIndex()
		demod = self.ui.demodulationEnable.currentIndex()
		if averaging != 0 and demod != 0:
			self.ui.uxaVSAAdv.setStyleSheet(boxDone)
			setButton.setText("Unset")
			self.ui.statusBar.showMessage('Successfully Set Advanced Settings',2000)
		else:
			self.fillParametersMsg()
			self.ui.uxaVSASetAdv.setChecked(False)
	elif  setButton.isChecked() == False:
		self.ui.uxaVSAAdv.setStyleSheet(None)
		setButton.setText("Set")
def setDown(self,buttonFocus,greyHover,buttonHover,boxDone,setButton):
	#meterChecked = self.ui.meterSet.isChecked()
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
	elif  setButton.isChecked() == False:
		self.ui.downEquip.setStyleSheet(None)
		setButton.setText("Set")
def setMeter(self,buttonFocus,buttonHover,greyHover,boxDone,setButton,supply):
	if setButton.isChecked() == True:
		flag = 0;
		setButton.setText("Unset")
		
		averaging = "0"
		if self.ui.powerMeterFilter.currentIndex() == 1:
			averaging = "-1"
		elif self.ui.powerMeterFilter.currentIndex() == 3:
			averaging = "-2"
		elif self.ui.powerMeterFilter.currentIndex() == 2:
			averaging = self.ui.noAveragesField_meter.toPlainText()
		
		flag = setPowerMeterParams(self, self.ui.powerMeterAddress, self.ui.powerMeterOffset, self.ui.powerMeterFrequency,self.ui.powerMeterPartNum,self.ui.meterEquip,boxDone,supply,averaging)
		
		
			
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
	elif  setButton.isChecked() == False:
		self.ui.meterEquip.setStyleSheet(None)
		setButton.setText("Set")
def setSA(self,buttonFocus,buttonHover,greyHover,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
	
		
		
		self.ui.saButton_sa.setStyleSheet(buttonFocus)
		self.ui.saButton_sa_2.setStyleSheet(buttonFocus)
		self.ui.saButton_sa_3.setStyleSheet(buttonFocus)
		self.ui.saButton_sa_4.setStyleSheet(buttonFocus)
		setPrevSAButtons(self,buttonHover,greyHover)
		self.ui.saEquip.setStyleSheet(boxDone)
		
		self.ui.saNextStack.setCurrentIndex(0)
		self.ui.meterNextStack.setCurrentIndex(2)
		self.ui.downNextStack.setCurrentIndex(3)
		self.ui.vsaNextStack.setCurrentIndex(5)
		self.ui.up_psg_next.setCurrentIndex(7)
		self.ui.vsgNextSteps.setCurrentIndex(9)
	elif  setButton.isChecked() == False:
		self.ui.saEquip.setStyleSheet(None)
		setButton.setText("Set")
	
def setP1(self,boxDone,buttonFocus,buttonHover,greyHover,greyButton,supply,buttonSelect,setButton):
	if setButton.isChecked() == True:
		flag = 0;
		c1Checked = self.ui.p1c1Check.isChecked()
		c2Checked = self.ui.p1c2Check.isChecked()
		c3Checked = self.ui.p1c3Check.isChecked()
		c4Checked = self.ui.p1c4Check.isChecked()
		vsgType = self.ui.vsgSetup.currentIndex()
		vsaType = self.ui.vsaType.currentIndex()
		enabledSupply = self.ui.p1Enabled.currentIndex()
		p1c1A = self.ui.p1c1Address.toPlainText()
		p1c2A = self.ui.p1c2Address.toPlainText()
		p1c3A = self.ui.p1c3Address.toPlainText()
		p1c4A = self.ui.p1c4Address.toPlainText()
		
		# set instrument params
		if enabledSupply == 0 or enabledSupply == 2:
			if enabledSupply == 2:
				flag = 1;
			if enabledSupply == 0:
				instrParamErrorMessage(self,"Please fill out the current equipment's parameters before moving on.")
				setButton.setChecked(False)
			if p1c1A != "":
				supply.Output_Toggle(p1c1A,nargout=0)
			if p1c2A != "":
				supply.Output_Toggle(p1c2A,nargout=0)
			if p1c3A != "":
				supply.Output_Toggle(p1c3A,nargout=0)
			if p1c4A != "":
				supply.Output_Toggle(p1c4A,nargout=0)
		else:
			if c1Checked == False and c2Checked == False and c3Checked == False and c4Checked == False:
				instrParamErrorMessage(self,"Please enable and set channel parameters if this supply is in use.")
				setButton.setChecked(False)
			if c1Checked:
				flag = setSupplyParams(self,self.ui.p1c1Address,self.ui.p1c1Voltage,self.ui.p1c1Current,self.ui.p1c1PartNumber,self.ui.p1c1Equip,boxDone,supply,1)
			if c2Checked:
				flag = setSupplyParams(self,self.ui.p1c2Address,self.ui.p1c2Voltage,self.ui.p1c2Current,self.ui.p1c2PartNumber,self.ui.p1c2Equip,boxDone,supply,2)
			if c3Checked:
				flag = setSupplyParams(self,self.ui.p1c3Address,self.ui.p1c3Voltage,self.ui.p1c3Current,self.ui.p1c3PartNumber,self.ui.p1c3Equip,boxDone,supply,3)
			if c4Checked:
				flag = setSupplyParams(self,self.ui.p1c4Address,self.ui.p1c4Voltage,self.ui.p1c4Current,self.ui.p1c4PartNumber,self.ui.p1c4Equip,boxDone,supply,4)
		
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

def setP2(self,boxDone,buttonFocus,buttonHover,greyHover,greyButton,supply,buttonSelect,setButton):
	if setButton.isChecked() == True:
		flag = 0;
		c1Checked = self.ui.p2c1Check.isChecked()
		c2Checked = self.ui.p2c2Check.isChecked()
		c3Checked = self.ui.p2c3Check.isChecked()
		c4Checked = self.ui.p2c4Check.isChecked()
		vsaType = self.ui.vsaType.currentIndex()
		enabledSupply = self.ui.p2Enabled.currentIndex()
		p2c1A = self.ui.p2c1Address.toPlainText()
		p2c2A = self.ui.p2c2Address.toPlainText()
		p2c3A = self.ui.p2c3Address.toPlainText()
		p2c4A = self.ui.p2c3Address.toPlainText()
		
		# set instrument params
		if enabledSupply == 0 or enabledSupply == 2:
			if enabledSupply == 2:
				flag = 1;
			if enabledSupply == 0:
				instrParamErrorMessage(self,"Please fill out the current equipment's parameters before moving on.")
				setButton.setChecked(False)
			if p2c1A != "":
				supply.Output_Toggle(p2c1A,nargout=0)
			if p2c2A != "":
				supply.Output_Toggle(p2c2A,nargout=0)
			if p2c3A != "":
				supply.Output_Toggle(p2c3A,nargout=0)
			if p2c4A != "":
				supply.Output_Toggle(p2c4A,nargout=0)
		else:
			if c1Checked == False and c2Checked == False and c3Checked == False and c4Checked == False:
				instrParamErrorMessage(self,"Please enable and set channel parameters if this supply is in use.")
				setButton.setChecked(False)
			if c1Checked:
				flag = setSupplyParams(self,self.ui.p2c1Address,self.ui.p2c1Voltage,self.ui.p2c1Current,self.ui.p2c1PartNumber,self.ui.p2c1Equip,boxDone,supply)
			if c2Checked:
				flag = setSupplyParams(self,self.ui.p2c2Address,self.ui.p2c2Voltage,self.ui.p2c2Current,self.ui.p2c2PartNumber,self.ui.p2c2Equip,boxDone,supply)
			if c3Checked:
				flag = setSupplyParams(self,self.ui.p2c3Address,self.ui.p2c3Voltage,self.ui.p2c3Current,self.ui.p2c3PartNumber,self.ui.p2c3Equip,boxDone,supply)
			if c4Checked:
				flag = setSupplyParams(self,self.ui.p2c4Address,self.ui.p2c4Voltage,self.ui.p2c4Current,self.ui.p2c4PartNumber,self.ui.p2c4Equip,boxDone,supply)
		
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
	
def setP3(self,boxDone,buttonFocus,buttonHover,supply,buttonSelect,greyHover,setButton):
	if setButton.isChecked() == True:
		flag = 0;
		c1Checked = self.ui.p3c1Check.isChecked()
		c2Checked = self.ui.p3c2Check.isChecked()
		c3Checked = self.ui.p3c3Check.isChecked()
		c4Checked = self.ui.p3c4Check.isChecked()
		enabledSupply = self.ui.p3Enabled.currentIndex()
		p3c1A = self.ui.p3c1Address.toPlainText()
		p3c2A = self.ui.p3c2Address.toPlainText()
		p3c3A = self.ui.p3c3Address.toPlainText()
		p3c4A = self.ui.p3c4Address.toPlainText()

		# set instrument params
		if enabledSupply == 0 or enabledSupply == 2:
			if enabledSupply == 2:
				flag = 1;
			if enabledSupply == 0:
				instrParamErrorMessage(self,"Please fill out the current equipment's parameters before moving on.")
				setButton.setChecked(False)
			if p3c1A != "":
				supply.Output_Toggle(p3c1A,nargout=0)
			if p3c2A != "":
				supply.Output_Toggle(p3c2A,nargout=0)
			if p3c3A != "":
				supply.Output_Toggle(p3c3A,nargout=0)
			if p3c4A != "":
				supply.Output_Toggle(p3c4A,nargout=0)
		else:
			if c1Checked == False and c2Checked == False and c3Checked == False and c4Checked == False:
				instrParamErrorMessage(self,"Please enable and set channel parameters if this supply is in use.")
				setButton.setChecked(False)
			if c1Checked:
				flag = setSupplyParams(self,self.ui.p3c1Address,self.ui.p3c1Voltage,self.ui.p3c1Current,self.ui.p3c1PartNumber,self.ui.p3c1Equip,boxDone,supply)
			if c2Checked:
				flag = setSupplyParams(self,self.ui.p3c2Address,self.ui.p3c2Voltage,self.ui.p3c2Current,self.ui.p3c2PartNumber,self.ui.p3c2Equip,boxDone,supply)
			if c3Checked:
				flag = setSupplyParams(self,self.ui.p3c3Address,self.ui.p3c3Voltage,self.ui.p3c3Current,self.ui.p3c3PartNumber,self.ui.p3c3Equip,boxDone,supply)
			if c4Checked:
				flag = setSupplyParams(self,self.ui.p3c4Address,self.ui.p3c4Voltage,self.ui.p3c4Current,self.ui.p3c4PartNumber,self.ui.p3c4Equip,boxDone,supply)
		
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
			
def setVSAMeasDig(self,boxDone,buttonHover,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
				setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonHover)
			else:
				self.ui.vsaMeasNextStack.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonHover)
		elif vsaType == 1: # has down
			self.ui.vsaMeasNextStack.setCurrentIndex(1)
	elif  setButton.isChecked() == False:
		self.ui.vsaMeasGenEquip.setStyleSheet(None)
		self.ui.vsaMeasGenEquip_2.setStyleSheet(None)
		self.ui.vsaMeasDigEquip.setStyleSheet(None)
		setButton.setText("Set")
def setVSAMeasGen(self,boxDone,buttonHover,setButton):
	if setButton.isChecked() == True:
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
				setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonHover)
			else:
				self.ui.vsaMeasNextStack.setCurrentIndex(5)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonHover)
				setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonHover)
		self.ui.vsaMeasNextStack.setCurrentIndex(1)
	elif  setButton.isChecked() == False:
		self.ui.vsaMeasGenEquip.setStyleSheet(None)
		self.ui.vsaMeasGenEquip_2.setStyleSheet(None)
		setButton.setText("Set")

def setVSAMeasAdv(self,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
		self.ui.vsaMeasAdvEquip.setStyleSheet(boxDone)
		self.ui.saMark_vsaMeas.setVisible(True)
		self.ui.saMark_vsaMeas_2.setVisible(True)
		self.ui.saMark_vsgMeas.setVisible(True)
		self.ui.saMark_vsgMeas_2.setVisible(True)
	elif  setButton.isChecked() == False:
		self.ui.vsaMeasAdvEquip.setStyleSheet(None)
		setButton.setText("Set")
	
def rxCalRoutine(self,boxDone,buttonHover,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
	elif  setButton.isChecked() == False:
		self.ui.combEquip_vsaMeas.setStyleSheet(None)
		self.ui.downEquip_vsaMeas.setStyleSheet(None)
		self.ui.rxEquip_vsaMeas.setStyleSheet(None)
		setButton.setText("Set")
def noRXCalRoutine(self,boxDone,buttonHover,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
			setFocusAndHand(self,self.ui.vsgButton_vsaMeas,buttonHover)
		else:
			self.ui.vsaMeasNextStack.setCurrentIndex(5)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas,buttonHover)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas_2,buttonHover)
			setFocusAndHand(self,self.ui.awgButton_vsaMeas_3,buttonHover)
	elif  setButton.isChecked() == False:
		self.ui.combEquip_vsaMeas.setStyleSheet(None)
		self.ui.downEquip_vsaMeas.setStyleSheet(None)
		self.ui.rxEquip_vsaMeas.setStyleSheet(None)
		setButton.setText("Set")
def awgCalRoutine(self,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
	elif  setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.awgEquip_vsgMeas.setStyleSheet(None)
		self.ui.rxEquip_vsgMeas.setStyleSheet(None)
		self.ui.vsgEquip_vsgMeas.setStyleSheet(None)
		self.ui.calEquip_vsgMeas.setStyleSheet(None)
def noAWGCalRoutine(self,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
		self.ui.awgEquip_vsgMeas_2.setStyleSheet(boxDone)
		self.ui.awgCalEquip_vsgMeas_2.setStyleSheet(boxDone)
		self.ui.vsgMeasNextStack.setCurrentIndex(5)
	elif  setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.awgEquip_vsgMeas_2.setStyleSheet(None)
		self.ui.awgCalEquip_vsgMeas_2.setStyleSheet(None)
def setAdvVSGMeas(self,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
		awgOnly = self.ui.setAdv_vsgMeas.isChecked()
		awgAndVSA = self.ui.setAdv_vsgMeas_2.isChecked()
		if awgOnly:
			self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(boxDone)
			self.ui.awgAdvEquip_vsgMeas.setStyleSheet(boxDone)
		if awgAndVSA:
			self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(boxDone)
			self.ui.awgAdvEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.vsaAdvEquip_vsgMeas.setStyleSheet(boxDone)
	elif  setButton.isChecked() == False:
		setButton.setText("Set")
		awgOnly = self.ui.setAdv_vsgMeas.isChecked()
		awgAndVSA = self.ui.setAdv_vsgMeas_2.isChecked()
		if awgOnly:
			self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(None)
			self.ui.awgAdvEquip_vsgMeas.setStyleSheet(None)
		if awgAndVSA:
			self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(None)
			self.ui.awgAdvEquip_vsgMeas.setStyleSheet(None)
			self.ui.vsaAdvEquip_vsgMeas.setStyleSheet(None)	
def awgPreview(self):
	self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(0)
	self.ui.resultsTabs_vsgMeas.setCurrentIndex(1)
	
def setUpVSGMeas(self,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
		awgChecked = self.ui.awgSet_vsgMeas.isChecked()
		awgRunChecked = self.ui.awgSetRun_vsgMeas.isChecked()
		if awgChecked or awgRunChecked:
			self.ui.upCalHomoEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.upCalHeteroEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.upEquip_vsgMeas.setStyleSheet(boxDone)
			self.ui.vsgMeasNextStack.setCurrentIndex(8)
	elif  setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.upCalHomoEquip_vsgMeas.setStyleSheet(None)
		self.ui.upCalHeteroEquip_vsgMeas.setStyleSheet(None)
		self.ui.upEquip_vsgMeas.setStyleSheet(None)
def setHetero(self,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
	elif  setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.calEquip_hetero.setStyleSheet(None)
		self.ui.rxEquip_hetero.setStyleSheet(None)
		self.ui.vsgEquip_hetero.setStyleSheet(None)
		self.ui.upCalEquipHomo_hetero.setStyleSheet(None)
		self.ui.upCalEquipHetero_hetero.setStyleSheet(None)
		self.ui.upEquip_hetero.setStyleSheet(None)
def setHomo(self,boxDone,setButton):
	if setButton.isChecked() == True:
		setButton.setText("Unset")
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
	elif  setButton.isChecked() == False:
		setButton.setText("Set")
		self.ui.calEquip_homo.setStyleSheet(None)
		self.ui.rxEquip_homo.setStyleSheet(None)
		self.ui.vsgEquip_homo.setStyleSheet(None)
		self.ui.upCalEquipHomo_homo.setStyleSheet(None)
		self.ui.upCalEquipHetero_homo.setStyleSheet(None)
		self.ui.upEquip_homo.setStyleSheet(None)
		self.ui.scopeEquip_homo.setStyleSheet(None)
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

def	setPrevSAButtons(self,buttonHover,greyHover):
	setFocusAndHand(self,self.ui.saButton_vsg,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsg_2,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsg_3,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsg_4,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsg_5,buttonHover)
	setFocusAndHand(self,self.ui.saButton_up,buttonHover)
	setFocusAndHand(self,self.ui.saButton_up_2,buttonHover)
	setFocusAndHand(self,self.ui.saButton_up_3,buttonHover)
	setFocusAndHand(self,self.ui.saButton_up_4,buttonHover)
	setFocusAndHand(self,self.ui.saButton_up_5,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsa,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsa_2,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsa_3,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsa_4,buttonHover)
	setFocusAndHand(self,self.ui.saButton_vsa_5,buttonHover)
	setFocusAndHand(self,self.ui.saButton_down,buttonHover)
	setFocusAndHand(self,self.ui.saButton_down_2,buttonHover)
	setFocusAndHand(self,self.ui.saButton_meter,buttonHover)
	setFocusAndHand(self,self.ui.saButton_meter_2,buttonHover)
	setFocusAndHand(self,self.ui.saButton_meter_3,buttonHover)
	setFocusAndHand(self,self.ui.saButton_meter_4,buttonHover)
	setFocusAndHand(self,self.ui.power1Button_sa,greyHover)
	setFocusAndHand(self,self.ui.power1Button_meter,greyHover)
	setFocusAndHand(self,self.ui.power1Button_down,greyHover)
	setFocusAndHand(self,self.ui.power1Button_vsa,greyHover)
	setFocusAndHand(self,self.ui.power1Button_up,greyHover)
	setFocusAndHand(self,self.ui.power1Button_vsg,greyHover)
	
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

def instrParamErrorMessage(self,error):
	msg = QMessageBox(self)
	msg.setIcon(QMessageBox.Critical)
	msg.setWindowTitle('Unable to Set Parameters')
	msg.setText(error)
	msg.setStandardButtons(QMessageBox.Ok)
	msg.exec_();

def setPowerMeterParams(self,address,offset,frequency,partNum,equipBox,boxDone,supply,averaging):	
	A = address.toPlainText()
	O = offset.toPlainText()
	F = frequency.toPlainText()
	
	
	result = supply.Set_Meter(A,O,F,averaging,nargout=1)
	result = result.split(";")
	error = result[1]

	if error == " " :
		
		powerMeterPartNum = result[0]
		partNum.setPlainText(powerMeterPartNum)
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	elif A == "":
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	else:
		
		instrParamErrorMessage(self,error)
		self.ui.meterSet.setChecked(False)
		
def setSupplyParams(self,address,voltage,current,partNum,equipBox,boxDone,supply,channel):
	A = address.toPlainText()
	V = voltage.toPlainText()
	C = current.toPlainText()
	result = supply.Set_Supply(A,V,C,channel,nargout=1)
	result = result.split(";")
	error = result[1]
	if error == " ":
		p1c3PartNum = result[0]
		partNum.setPlainText(p1c3PartNum)
		equipBox.setStyleSheet(boxDone)
		flag = 1
		return flag
	else:
		instrParamErrorMessage(self,error)
		self.ui.p1Set.setChecked(False)
# this file is for the update button field slots

# declare styling variables
greenButton = "QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 85, 0, 255), stop:1 rgba(0, 158, 0, 255));color:white;border-radius: 5px; border: 3px solid green;} QPushButton:hover{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 134, 0, 255), stop:1 rgba(0, 184, 0, 255));}"

def updateGenAWG(self):
	self.ui.awgEquipGeneral.setStyleSheet(None)
	self.ui.awgSetGeneral.setEnabled(True)
	self.ui.awgSetGeneral.setStyleSheet(greenButton)
		
def updateAdvAWG(self):
	self.ui.awgEquipAdv.setStyleSheet(None)
	self.ui.awgSetAdv.setEnabled(True)
	self.ui.awgSetAdv.setStyleSheet(greenButton)
	
def updateGenVSG(self):
	self.ui.vsgEquipGeneral.setStyleSheet(None)
	self.ui.vsgSetGeneral.setEnabled(True)
	self.ui.vsgSetGeneral.setStyleSheet(greenButton)
	
def updateAdvVSG(self):
	self.ui.vsgEquipAdv.setStyleSheet(None)
	self.ui.vsgSetAdv.setEnabled(True)
	self.ui.vsgSetAdv.setStyleSheet(greenButton)
	
def updateUp(self):
	self.ui.upEquip.setStyleSheet(None)
	self.ui.upSet.setEnabled(True)
	self.ui.upSet.setStyleSheet(greenButton)
	
def updatePSG(self):
	self.ui.psgEquip.setStyleSheet(None)
	self.ui.psgSet.setEnabled(True)
	self.ui.psgSet.setStyleSheet(greenButton)
	
def updateVSA(self):
	idx = self.ui.vsaType.currentIndex()
	if idx == 1 or idx == 5:
		self.ui.scopeEquipGeneral.setStyleSheet(None)
		self.ui.scopeMod.setStyleSheet(None)
		self.ui.scopeSet.setEnabled(True)
		self.ui.scopeSet.setStyleSheet(greenButton)
	elif idx == 2 or idx == 6:
		self.ui.digEquipGeneral.setStyleSheet(None)
		self.ui.digMod.setStyleSheet(None)
		self.ui.digSet.setEnabled(True)
		self.ui.digSet.setStyleSheet(greenButton)
	elif idx == 3 or idx == 4:
		self.ui.digEquipGeneral.setStyleSheet(None)
		self.ui.digMod.setStyleSheet(None)
		self.ui.digSet.setEnabled(True)
		self.ui.digSet.setStyleSheet(greenButton)
		
def updateAdvUXA(self):
	self.ui.uxaVSAAdv.setStyleSheet(None)
	self.ui.uxaVSASetAdv.setEnabled(True)
	self.ui.uxaVSASetAdv.setStyleSheet(greenButton)
	
def updateDown(self):
	self.ui.downEquip.setStyleSheet(None)
	self.ui.downSet.setEnabled(True)
	self.ui.downSet.setStyleSheet(greenButton)
	
def updateAdvDown(self):
	self.ui.downEquipAdv.setStyleSheet(None)
	self.ui.downSetAdv.setEnabled(True)
	self.ui.downSetAdv.setStyleSheet(greenButton)
	
def updateMeter(self):
	self.ui.meterEquip.setStyleSheet(None)
	self.ui.meterSet.setEnabled(True)
	self.ui.meterSet.setStyleSheet(greenButton)
	
def updateSA(self):
	self.ui.saEquip.setStyleSheet(None)
	self.ui.saSet.setEnabled(True)
	self.ui.saSet.setStyleSheet(greenButton)

	
	
	
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

def updateAdvSA(self):
	self.ui.saEquipAdv.setStyleSheet(None)
	self.ui.saSetAdv.setEnabled(True)
	self.ui.saSetAdv.setStyleSheet(greenButton)
	
def updateP1(self):
	self.ui.p1Equip.setStyleSheet(None)
	self.ui.p1Set.setEnabled(True)
	self.ui.p1Set.setStyleSheet(greenButton)
	
def updateP2(self):
	self.ui.p2Equip.setStyleSheet(None)
	self.ui.p2Set.setEnabled(True)
	self.ui.p2Set.setStyleSheet(greenButton)
	
def updateP3(self):
	self.ui.p3Equip.setStyleSheet(None)
	self.ui.p3Set.setEnabled(True)
	self.ui.p3Set.setStyleSheet(greenButton)
	
def updateVSAMeasDig(self):
	self.ui.vsaMeasGenEquip.setStyleSheet(None)
	self.ui.vsaMeasGenEquip_2.setStyleSheet(None)
	self.ui.vsaMeasDigEquip.setStyleSheet(None)
	self.ui.vsaMeasSet.setEnabled(True)
	self.ui.vsaMeasSet.setStyleSheet(greenButton)
	
def updateVSAMeas(self):
	self.ui.vsaMeasGenEquip.setStyleSheet(None)
	self.ui.vsaMeasGenEquip_2.setStyleSheet(None)
	self.ui.vsaMeasSet_2.setEnabled(True)
	self.ui.vsaMeasSet_2.setStyleSheet(greenButton)
	
def updateSAMeas(self):
	self.ui.vsaMeasAdvEquip.setStyleSheet(None)
	self.ui.vsaMeasAdvSet.setEnabled(True)
	self.ui.vsaMeasAdvSet.setStyleSheet(greenButton)
	
def updateRXCal(self):
	idx = self.ui.vsaMeasRunStack.currentIndex()
	
	self.ui.combEquip_vsaMeas.setStyleSheet(None)
	self.ui.downEquip_vsaMeas.setStyleSheet(None)
	self.ui.rxEquip_vsaMeas.setStyleSheet(None)
	self.ui.trigEquip_vsaMeas.setStyleSheet(None)
	if idx == 0:
		self.ui.set_run_vsa.setEnabled(True)
		self.ui.set_run_vsa.setStyleSheet(greenButton)
	elif idx == 1:
		self.ui.downSetVSAMeas.setEnabled(True)
		self.ui.downSetVSAMeas.setStyleSheet(greenButton)

def updateAWGCal(self):
	self.ui.awgEquip_vsgMeas.setStyleSheet(None)
	self.ui.awgAlgoSettings_awgCal.setStyleSheet(None)
	self.ui.awgCalEquip_vsgMeas.setStyleSheet(None)
	self.ui.rxEquip_vsgMeas.setStyleSheet(None)
	self.ui.calEquip_vsgMeas.setStyleSheet(None)
	self.ui.awgSetRun_vsgMeas.setEnabled(True)
	self.ui.awgSetRun_vsgMeas.setStyleSheet(greenButton)
	
def updateNoAWGCal(self):
	self.ui.awgEquip_vsgMeas_2.setStyleSheet(None)
	self.ui.awgSet_vsgMeas.setEnabled(True)
	self.ui.awgSet_vsgMeas.setStyleSheet(greenButton)
	
def updateVSGMeasAdv(self):
	self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(None)
	self.ui.awgAdvEquip_vsgMeas.setStyleSheet(None)
	self.ui.vsaAdvEquip_vsgMeas.setStyleSheet(None)
	self.ui.setAdv_vsgMeas_2.setEnabled(True)
	self.ui.setAdv_vsgMeas.setEnabled(True)
	self.ui.setAdv_vsgMeas_2.setStyleSheet(greenButton)
	self.ui.setAdv_vsgMeas.setStyleSheet(greenButton)
	
def updateAWGMeasAdv(self):
	self.ui.awgAdvEquip_vsgMeas_2.setStyleSheet(None)
	self.ui.awgAdvEquip_vsgMeas.setStyleSheet(None)
	self.ui.setAdv_vsgMeas.setEnabled(True)
	self.ui.setAdv_vsgMeas.setStyleSheet(greenButton)
	
def updateUpMeas(self):
	self.ui.upEquip_vsgMeas.setStyleSheet(None)
	self.ui.upSet_vsgMeas.setEnabled(True)
	self.ui.upSet_vsgMeas.setStyleSheet(greenButton)
	
def updateHetero(self):
	self.ui.calEquip_hetero.setStyleSheet(None)
	self.ui.rxEquip_hetero.setStyleSheet(None)
	self.ui.vsgEquip_hetero.setStyleSheet(None)
	self.ui.upCalEquipHetero_hetero.setStyleSheet(None)
	self.ui.upEquip_hetero.setStyleSheet(None)
	self.ui.heteroRun.setEnabled(True)
	self.ui.heteroRun.setStyleSheet(greenButton)
	
def updateHomo(self):
	self.ui.calEquip_homo.setStyleSheet(None)
	self.ui.rxEquip_homo.setStyleSheet(None)
	self.ui.vsgEquip_homo.setStyleSheet(None)
	self.ui.upCalEquipHomo_homo.setStyleSheet(None)
	self.ui.upEquip_homo.setStyleSheet(None)
	self.ui.scopeEquip_homo.setStyleSheet(None)
	self.ui.homoRun.setEnabled(True)
	self.ui.homoRun.setStyleSheet(greenButton)
	
def updateCalVal(self):
	self.ui.calValSignalEquip.setStyleSheet(None)
	self.ui.calValCalFilesEquip.setStyleSheet(None)
	self.ui.calValRefRXEquip.setStyleSheet(None)
	self.ui.calValVSGEquip.setStyleSheet(None)
	self.ui.calValRun.setEnabled(True)
	self.ui.calValRun.setStyleSheet(greenButton)
	
def updatePrechar(self):
	self.ui.precharSignalEquip.setStyleSheet(None)
	self.ui.precharCalFilesEquip.setStyleSheet(None)
	self.ui.precharRefRXEquip.setStyleSheet(None)
	self.ui.precharVSGEquip.setStyleSheet(None)
	self.ui.precharRun.setEnabled(True)
	self.ui.precharRun.setStyleSheet(greenButton)
	
def updateDPD(self):
	self.ui.dpdSignalEquip.setStyleSheet(None)
	self.ui.dpdCalFilesEquip.setStyleSheet(None)
	self.ui.dpdGeneralEquip.setStyleSheet(None)
	self.ui.dpdModelEquip.setStyleSheet(None)
	self.ui.dpdRefRXEquip.setStyleSheet(None)
	self.ui.dpdVSGEquip.setStyleSheet(None)
	self.ui.dpdTrainingEquip.setStyleSheet(None)
	self.ui.dpdRun.setEnabled(True)
	self.ui.dpdRun.setStyleSheet(greenButton)
	
	
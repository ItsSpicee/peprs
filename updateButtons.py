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
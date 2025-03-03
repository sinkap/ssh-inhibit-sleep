# Makefile for installing ssh-inhibit-sleep script and systemd service

INSTALL_DIR = /usr/local/bin
SYSTEMD_SERVICE_DIR = /etc/systemd/system
SERVICE_NAME = ssh-inhibit-sleep

.PHONY: all install clean

# Default target: install the files
all: install

# Install the script and systemd files
install:
	# Install script to /usr/local/bin
	install -m 755 ssh-inhibit-sleep.sh $(INSTALL_DIR)/ssh-inhibit-sleep.sh

	# Install systemd service and timer to /etc/systemd/system
	install -m 644 ssh-inhibit-sleep.service $(SYSTEMD_SERVICE_DIR)/ssh-inhibit-sleep.service
	install -m 644 ssh-inhibit-sleep.timer $(SYSTEMD_SERVICE_DIR)/ssh-inhibit-sleep.timer

	# Reload systemd manager and enable/start the service and timer
	systemctl daemon-reload
	systemctl enable $(SERVICE_NAME).service
	systemctl enable $(SERVICE_NAME).timer
	systemctl start $(SERVICE_NAME).timer

	@echo "Installation complete. Service and timer enabled and started."

# Clean up installed files (optional)
clean:
	# Stop and disable services and timers before removing files
	systemctl stop $(SERVICE_NAME).timer
	systemctl disable $(SERVICE_NAME).timer
	systemctl stop $(SERVICE_NAME).service
	systemctl disable $(SERVICE_NAME).service

	# Remove the installed files
	rm -f $(INSTALL_DIR)/ssh-inhibit-sleep.sh
	rm -f $(SYSTEMD_SERVICE_DIR)/ssh-inhibit-sleep.service
	rm -f $(SYSTEMD_SERVICE_DIR)/ssh-inhibit-sleep.timer

	@echo "Cleanup complete."


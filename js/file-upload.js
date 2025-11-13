/**
 * File Upload Handler
 * Handles drag-and-drop and browse file upload functionality
 */

class FileUploader {
  constructor(uploadZoneSelector) {
    this.uploadZones = document.querySelectorAll(uploadZoneSelector || '.upload-zone');
    this.maxFileSize = 50 * 1024 * 1024; // 50MB
    this.allowedTypes = [
      'text/csv',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/json'
    ];
    this.allowedExtensions = ['.csv', '.xls', '.xlsx', '.json'];
    this.init();
  }

  init() {
    this.uploadZones.forEach(zone => {
      this.setupDropZone(zone);
      this.setupBrowseButton(zone);
    });
  }

  setupDropZone(zone) {
    // Prevent default drag behaviors
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
      zone.addEventListener(eventName, this.preventDefaults, false);
    });

    // Highlight drop zone when item is dragged over it
    ['dragenter', 'dragover'].forEach(eventName => {
      zone.addEventListener(eventName, () => {
        zone.classList.add('drag-over');
      }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
      zone.addEventListener(eventName, () => {
        zone.classList.remove('drag-over');
      }, false);
    });

    // Handle dropped files
    zone.addEventListener('drop', (e) => {
      const files = e.dataTransfer.files;
      this.handleFiles(files, zone);
    }, false);
  }

  setupBrowseButton(zone) {
    const browseButton = zone.querySelector('button');

    if (!browseButton) return;

    // Create hidden file input
    const fileInput = document.createElement('input');
    fileInput.type = 'file';
    fileInput.accept = this.allowedExtensions.join(',');
    fileInput.style.display = 'none';

    // Add to DOM
    zone.appendChild(fileInput);

    // Handle button click
    browseButton.addEventListener('click', (e) => {
      e.preventDefault();
      fileInput.click();
    });

    // Handle file selection
    fileInput.addEventListener('change', (e) => {
      this.handleFiles(e.target.files, zone);
    });
  }

  preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  handleFiles(files, zone) {
    if (files.length === 0) return;

    const file = files[0];

    // Validate file
    const validation = this.validateFile(file);

    if (!validation.valid) {
      this.showError(validation.message, zone);
      return;
    }

    // Show file preview
    this.showFilePreview(file, zone);
  }

  validateFile(file) {
    // Check file size
    if (file.size > this.maxFileSize) {
      return {
        valid: false,
        message: `File size exceeds ${this.maxFileSize / (1024 * 1024)}MB limit`
      };
    }

    // Check file type
    const extension = '.' + file.name.split('.').pop().toLowerCase();

    if (!this.allowedExtensions.includes(extension)) {
      return {
        valid: false,
        message: `Invalid file type. Allowed: ${this.allowedExtensions.join(', ')}`
      };
    }

    return { valid: true };
  }

  showFilePreview(file, zone) {
    // Find the tab we're in
    const tabContent = zone.closest('[id^="content-"]');
    const tabId = tabContent ? tabContent.id.replace('content-', '') : 'google';

    // Hide upload zone
    zone.style.display = 'none';

    // Get or create preview container
    let preview = document.getElementById(`${tabId}-file-preview`);

    if (!preview) {
      preview = this.createPreviewElement(tabId);
      zone.parentElement.appendChild(preview);
    }

    // Update preview with file info
    this.updatePreview(preview, file);

    // Show preview
    preview.classList.remove('hidden');

    // Setup upload button
    const uploadButton = preview.querySelector('button[class*="bg-purple"]');
    if (uploadButton) {
      uploadButton.onclick = () => this.uploadFile(file, zone, preview);
    }

    // Setup remove button
    const removeButton = preview.querySelector('button[class*="text-red"]');
    if (removeButton) {
      removeButton.onclick = () => this.removeFile(zone, preview);
    }
  }

  createPreviewElement(tabId) {
    const preview = document.createElement('div');
    preview.id = `${tabId}-file-preview`;
    preview.className = 'hidden';
    preview.innerHTML = `
      <h4 class="font-semibold text-gray-800 mb-3">Selected File</h4>
      <div class="file-item bg-gray-50 rounded-lg p-4 flex items-center justify-between mb-4">
        <div class="flex items-center space-x-4">
          <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
            <i class="fas fa-file-excel text-green-600 text-xl"></i>
          </div>
          <div>
            <p class="font-medium text-gray-900 file-name">filename.xlsx</p>
            <p class="text-sm text-gray-500 file-info">2.4 MB • Ready to upload</p>
          </div>
        </div>
        <button class="text-red-600 hover:text-red-700">
          <i class="fas fa-times text-xl"></i>
        </button>
      </div>
      <button class="w-full bg-purple-600 text-white py-3 rounded-lg hover:bg-purple-700 transition font-medium">
        <i class="fas fa-upload mr-2"></i>Upload File
      </button>
    `;
    return preview;
  }

  updatePreview(preview, file) {
    const fileName = preview.querySelector('.file-name');
    const fileInfo = preview.querySelector('.file-info');
    const fileIcon = preview.querySelector('.fa-file-excel');

    if (fileName) fileName.textContent = file.name;
    if (fileInfo) fileInfo.textContent = `${this.formatFileSize(file.size)} • Ready to upload`;

    // Update icon based on file type
    if (fileIcon) {
      const extension = file.name.split('.').pop().toLowerCase();
      if (extension === 'json') {
        fileIcon.className = 'fas fa-file-code text-purple-600 text-xl';
      } else if (extension === 'csv') {
        fileIcon.className = 'fas fa-file-csv text-blue-600 text-xl';
      } else {
        fileIcon.className = 'fas fa-file-excel text-green-600 text-xl';
      }
    }
  }

  formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
  }

  async uploadFile(file, zone, preview) {
    const tabContent = zone.closest('[id^="content-"]');
    const tabId = tabContent ? tabContent.id.replace('content-', '') : 'google';

    // Show loading state
    const uploadButton = preview.querySelector('button[class*="bg-purple"]');
    if (uploadButton) {
      uploadButton.disabled = true;
      uploadButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Uploading...';
    }

    try {
      // Simulate upload (replace with actual API call)
      await this.simulateUpload(file);

      // Show success message
      this.showSuccess(tabId, file);

      // Hide preview
      preview.classList.add('hidden');

    } catch (error) {
      console.error('Upload error:', error);
      this.showError(error.message || 'Upload failed', zone);

      // Reset button
      if (uploadButton) {
        uploadButton.disabled = false;
        uploadButton.innerHTML = '<i class="fas fa-upload mr-2"></i>Upload File';
      }
    }
  }

  async simulateUpload(file) {
    // Simulate API call delay
    return new Promise((resolve) => {
      setTimeout(() => {
        console.log('File uploaded:', file.name);
        resolve();
      }, 2000);
    });
  }

  removeFile(zone, preview) {
    preview.classList.add('hidden');
    zone.style.display = '';
  }

  showSuccess(tabId, file) {
    let successDiv = document.getElementById(`${tabId}-success`);

    if (!successDiv) {
      const tabContent = document.getElementById(`content-${tabId}`);
      successDiv = this.createSuccessElement(tabId, file);
      if (tabContent) {
        tabContent.appendChild(successDiv);
      }
    }

    // Update success stats (mock data)
    const rowsImported = Math.floor(Math.random() * 2000) + 500;
    const campaigns = Math.floor(Math.random() * 20) + 5;

    const statsElements = successDiv.querySelectorAll('.text-2xl');
    if (statsElements[0]) statsElements[0].textContent = rowsImported.toLocaleString();
    if (statsElements[1]) statsElements[1].textContent = '0';
    if (statsElements[2]) statsElements[2].textContent = campaigns;

    successDiv.classList.remove('hidden');

    // Hide after 5 seconds
    setTimeout(() => {
      successDiv.classList.add('hidden');
      // Reset upload zone
      const uploadZone = document.querySelector(`#content-${tabId} .upload-zone`);
      if (uploadZone) uploadZone.style.display = '';
    }, 5000);
  }

  createSuccessElement(tabId, file) {
    const successDiv = document.createElement('div');
    successDiv.id = `${tabId}-success`;
    successDiv.className = 'hidden';
    successDiv.innerHTML = `
      <div class="bg-green-50 border border-green-200 rounded-lg p-6 text-center">
        <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
          <i class="fas fa-check text-green-600 text-2xl"></i>
        </div>
        <h4 class="text-xl font-semibold text-green-900 mb-2">Upload Successful!</h4>
        <p class="text-green-700 mb-4">Your data has been processed successfully</p>
        <div class="grid grid-cols-3 gap-4 max-w-2xl mx-auto mb-4">
          <div class="bg-white rounded-lg p-4">
            <p class="text-2xl font-bold text-gray-900">1,247</p>
            <p class="text-sm text-gray-600">Rows Imported</p>
          </div>
          <div class="bg-white rounded-lg p-4">
            <p class="text-2xl font-bold text-gray-900">0</p>
            <p class="text-sm text-gray-600">Errors Found</p>
          </div>
          <div class="bg-white rounded-lg p-4">
            <p class="text-2xl font-bold text-gray-900">15</p>
            <p class="text-sm text-gray-600">Campaigns</p>
          </div>
        </div>
        <button onclick="window.location='index.html'" class="bg-purple-600 text-white px-6 py-2 rounded-lg hover:bg-purple-700 transition">
          View Dashboard
        </button>
      </div>
    `;
    return successDiv;
  }

  showError(message, zone) {
    // Create error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'bg-red-50 border border-red-200 rounded-lg p-4 mb-4 flex items-start';
    errorDiv.innerHTML = `
      <i class="fas fa-exclamation-circle text-red-600 text-xl mr-3 mt-1"></i>
      <div>
        <h4 class="font-semibold text-red-900 mb-1">Upload Error</h4>
        <p class="text-red-700 text-sm">${message}</p>
      </div>
      <button class="ml-auto text-red-600 hover:text-red-700">
        <i class="fas fa-times"></i>
      </button>
    `;

    // Add close functionality
    const closeButton = errorDiv.querySelector('button');
    closeButton.addEventListener('click', () => errorDiv.remove());

    // Insert before upload zone
    zone.parentElement.insertBefore(errorDiv, zone);

    // Auto-remove after 5 seconds
    setTimeout(() => errorDiv.remove(), 5000);
  }
}

// Initialize file uploader when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    new FileUploader('.upload-zone');
  });
} else {
  new FileUploader('.upload-zone');
}

// Export for use in other scripts
if (typeof window !== 'undefined') {
  window.FileUploader = FileUploader;
}

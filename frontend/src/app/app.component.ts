import { Component, OnInit } from '@angular/core';

import { Complaint, ComplaintProgress, ComplaintStatus, CreateComplaintRequest } from './complaint.model';
import { ComplaintService } from './complaint.service';

type Portal = 'citizen' | 'admin';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent implements OnInit {
  selectedPortal: Portal = 'citizen';

  citizenProgress: ComplaintProgress[] = [];
  adminComplaints: Complaint[] = [];

  loadingCitizen = false;
  loadingAdmin = false;
  savingComplaint = false;

  citizenError = '';
  adminError = '';

  formModel: CreateComplaintRequest = {
    title: '',
    description: '',
    location: '',
    category: 'Road'
  };

  readonly categories = ['Road', 'Sanitation', 'Water', 'Electricity', 'Public Safety', 'Other'];
  readonly statuses: ComplaintStatus[] = ['Open', 'In Progress', 'Dismissed', 'Done'];

  constructor(private readonly complaintService: ComplaintService) {}

  ngOnInit(): void {
    this.loadCitizenProgress();
    this.loadAdminComplaints();
  }

  selectPortal(portal: Portal): void {
    this.selectedPortal = portal;
    if (portal === 'citizen' && this.citizenProgress.length === 0) {
      this.loadCitizenProgress();
    }
    if (portal === 'admin' && this.adminComplaints.length === 0) {
      this.loadAdminComplaints();
    }
  }

  submitComplaint(): void {
    if (!this.formModel.title.trim() || !this.formModel.description.trim() || !this.formModel.location.trim()) {
      this.citizenError = 'Title, Description, and Location are required.';
      return;
    }

    this.savingComplaint = true;
    this.citizenError = '';

    const payload: CreateComplaintRequest = {
      title: this.formModel.title.trim(),
      description: this.formModel.description.trim(),
      location: this.formModel.location.trim(),
      category: this.formModel.category
    };

    this.complaintService.createComplaint(payload).subscribe({
      next: () => {
        this.formModel = {
          title: '',
          description: '',
          location: '',
          category: 'Road'
        };
        this.savingComplaint = false;
        this.loadCitizenProgress();
        this.loadAdminComplaints();
      },
      error: () => {
        this.citizenError = 'Could not submit complaint. Please try again.';
        this.savingComplaint = false;
      }
    });
  }

  loadCitizenProgress(): void {
    this.loadingCitizen = true;
    this.citizenError = '';

    this.complaintService.getAllProgress().subscribe({
      next: (data) => {
        this.citizenProgress = data;
        this.loadingCitizen = false;
      },
      error: () => {
        this.citizenError = 'Could not load complaint progress.';
        this.loadingCitizen = false;
      }
    });
  }

  loadAdminComplaints(): void {
    this.loadingAdmin = true;
    this.adminError = '';

    this.complaintService.getAllComplaintsForAdmin().subscribe({
      next: (data) => {
        this.adminComplaints = data;
        this.loadingAdmin = false;
      },
      error: () => {
        this.adminError = 'Could not load complaints for admin.';
        this.loadingAdmin = false;
      }
    });
  }

  updateStatus(complaint: Complaint, status: ComplaintStatus): void {
    if (complaint.status === status) {
      return;
    }

    this.adminError = '';
    this.complaintService.updateStatus(complaint.id, status).subscribe({
      next: (updated) => {
        complaint.status = updated.status;
        complaint.updatedAtUtc = updated.updatedAtUtc;
        this.loadCitizenProgress();
      },
      error: () => {
        this.adminError = 'Could not update complaint #' + complaint.id + '.';
      }
    });
  }

  statusClass(status: ComplaintStatus): string {
    if (status === 'In Progress') {
      return 'status-in-progress';
    }
    if (status === 'Dismissed') {
      return 'status-dismissed';
    }
    if (status === 'Done') {
      return 'status-done';
    }
    return 'status-open';
  }

  trackById(_: number, item: { id: number }): number {
    return item.id;
  }
}

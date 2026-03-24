import { Component, OnInit } from '@angular/core';

import { Complaint, CreateComplaintRequest } from './complaint.model';
import { ComplaintService } from './complaint.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent implements OnInit {
  complaints: Complaint[] = [];
  loading = false;
  saving = false;
  errorMessage = '';

  formModel: CreateComplaintRequest = {
    title: '',
    description: '',
    location: '',
    category: 'Road'
  };

  readonly categories = ['Road', 'Sanitation', 'Water', 'Electricity', 'Public Safety', 'Other'];
  readonly statuses = ['Open', 'In Progress', 'Resolved', 'Closed'];

  constructor(private readonly complaintService: ComplaintService) {}

  ngOnInit(): void {
    this.loadComplaints();
  }

  loadComplaints(): void {
    this.loading = true;
    this.errorMessage = '';

    this.complaintService.getAll().subscribe({
      next: (data) => {
        this.complaints = data;
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Could not load complaints. Please try again.';
        this.loading = false;
      }
    });
  }

  submitComplaint(): void {
    if (!this.formModel.title.trim() || !this.formModel.description.trim() || !this.formModel.location.trim()) {
      this.errorMessage = 'Title, Description, and Location are required.';
      return;
    }

    this.saving = true;
    this.errorMessage = '';

    const payload: CreateComplaintRequest = {
      title: this.formModel.title.trim(),
      description: this.formModel.description.trim(),
      location: this.formModel.location.trim(),
      category: this.formModel.category
    };

    this.complaintService.create(payload).subscribe({
      next: () => {
        this.formModel = {
          title: '',
          description: '',
          location: '',
          category: 'Road'
        };
        this.saving = false;
        this.loadComplaints();
      },
      error: () => {
        this.errorMessage = 'Could not submit complaint. Please try again.';
        this.saving = false;
      }
    });
  }

  onStatusChange(complaint: Complaint, status: string): void {
    if (complaint.status === status) {
      return;
    }

    this.complaintService.updateStatus(complaint.id, status).subscribe({
      next: (updated) => {
        complaint.status = updated.status;
      },
      error: () => {
        this.errorMessage = `Could not update status for complaint #${complaint.id}.`;
      }
    });
  }

  trackByComplaintId(_: number, complaint: Complaint): number {
    return complaint.id;
  }
}

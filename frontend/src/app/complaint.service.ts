import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { Complaint, ComplaintProgress, ComplaintStatus, CreateComplaintRequest } from './complaint.model';

@Injectable({
  providedIn: 'root'
})
export class ComplaintService {
  private readonly complaintUrl = '/api/complaints';
  private readonly progressUrl = '/api/progress';
  private readonly adminUrl = '/api/admin/complaints';

  constructor(private readonly http: HttpClient) {}

  createComplaint(payload: CreateComplaintRequest): Observable<Complaint> {
    return this.http.post<Complaint>(this.complaintUrl, payload);
  }

  getAllComplaintsForAdmin(): Observable<Complaint[]> {
    return this.http.get<Complaint[]>(this.adminUrl);
  }

  getAllProgress(): Observable<ComplaintProgress[]> {
    return this.http.get<ComplaintProgress[]>(this.progressUrl);
  }

  updateStatus(id: number, status: ComplaintStatus): Observable<Complaint> {
    return this.http.put<Complaint>(`${this.adminUrl}/${id}/status`, { status });
  }
}

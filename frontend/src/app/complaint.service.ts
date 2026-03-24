import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { Complaint, CreateComplaintRequest } from './complaint.model';

@Injectable({
  providedIn: 'root'
})
export class ComplaintService {
  private readonly baseUrl = '/api/complaints';

  constructor(private readonly http: HttpClient) {}

  getAll(): Observable<Complaint[]> {
    return this.http.get<Complaint[]>(this.baseUrl);
  }

  create(payload: CreateComplaintRequest): Observable<Complaint> {
    return this.http.post<Complaint>(this.baseUrl, payload);
  }

  updateStatus(id: number, status: string): Observable<Complaint> {
    return this.http.put<Complaint>(`${this.baseUrl}/${id}/status`, { status });
  }
}

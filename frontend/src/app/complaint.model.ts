export type ComplaintStatus = 'Open' | 'In Progress' | 'Dismissed' | 'Done';

export interface Complaint {
  id: number;
  title: string;
  description: string;
  location: string;
  category: string;
  status: ComplaintStatus;
  createdAtUtc: string;
  updatedAtUtc: string;
}

export interface ComplaintProgress {
  id: number;
  title: string;
  location: string;
  category: string;
  status: ComplaintStatus;
  createdAtUtc: string;
  updatedAtUtc: string;
}

export interface CreateComplaintRequest {
  title: string;
  description: string;
  location: string;
  category: string;
}

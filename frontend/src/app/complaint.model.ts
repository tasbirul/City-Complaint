export interface Complaint {
  id: number;
  title: string;
  description: string;
  location: string;
  category: string;
  status: string;
  createdAtUtc: string;
}

export interface CreateComplaintRequest {
  title: string;
  description: string;
  location: string;
  category: string;
}

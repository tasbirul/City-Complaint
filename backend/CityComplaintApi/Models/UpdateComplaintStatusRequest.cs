using System.ComponentModel.DataAnnotations;

namespace CityComplaintApi.Models;

public class UpdateComplaintStatusRequest
{
    [Required]
    [MaxLength(40)]
    public string Status { get; set; } = string.Empty;
}

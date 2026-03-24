using AdminService.Data;
using AdminService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AdminService.Controllers;

[ApiController]
[Route("api/admin/complaints")]
public class AdminController(AppDbContext dbContext) : ControllerBase
{
    private static readonly HashSet<string> ValidStatuses =
    ["Open", "In Progress", "Dismissed", "Done"];

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Complaint>>> GetAll()
    {
        var complaints = await dbContext.Complaints
            .OrderByDescending(c => c.CreatedAtUtc)
            .ToListAsync();

        return Ok(complaints);
    }

    [HttpPut("{id:int}/status")]
    public async Task<ActionResult<Complaint>> UpdateStatus(int id, [FromBody] UpdateComplaintStatusRequest request)
    {
        var nextStatus = request.Status.Trim();

        if (!ValidStatuses.Contains(nextStatus))
        {
            return BadRequest(new { error = "Invalid status. Use Open, In Progress, Dismissed, or Done." });
        }

        var complaint = await dbContext.Complaints.FindAsync(id);
        if (complaint is null)
        {
            return NotFound();
        }

        complaint.Status = nextStatus;
        complaint.UpdatedAtUtc = DateTime.UtcNow;

        await dbContext.SaveChangesAsync();

        return Ok(complaint);
    }
}

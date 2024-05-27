namespace Web_.Net_Assignment_With_Authentication.Models
{
    public class Record
    {
        public Guid Id { get; set; }
        public string Email { get; set; }
        public string Title { get; set; }
        public string Comment { get; set; }
        public DateTime? Date { get; set; }
    }
}

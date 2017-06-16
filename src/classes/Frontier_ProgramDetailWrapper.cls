public class Frontier_ProgramDetailWrapper {
    public Integer Available {get;set;}
    public Integer Consumed {get;set;}
    public Integer Allocated {get;set;}
    public String Budget {get;set;}
    public Integer VolumeGrowth {get;set;}
    public Integer CSGrowth {get;set;}
    public Integer Growth {get;set;}
    public String ProgramName {get;set;}
    public String BrandFamily {get;set;}
    public String ProgramCoverage {get;set;}
    public Id Id {get;set;}
    public Integer AquireCount {get;set;}
    public Integer RetainCount {get;set;}
    public Integer LtCount {get;set;}
    public Integer DevelopCount {get;set;}
    
    public Frontier_ProgramDetailWrapper(){
        this.VolumeGrowth = 0;
        this.CSGrowth = 0;
        this.Growth = 0;
        this.Available = 0;
        this.Consumed = 0;
        this.Allocated = 0;
        this.AquireCount = 0;
        this.RetainCount = 0;
        this.LtCount = 0;
        this.DevelopCount = 0;
    }
}
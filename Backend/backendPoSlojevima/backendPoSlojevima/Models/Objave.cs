using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class Objave : IEquatable<Objave>
    {
        public long id { get; set; }
        public long idTipa { get; set; }
        public long KorisnikID { get; set; }
        public virtual Korisnik korisnik { get; set; }
        public long GradID { get; set; }
        public virtual Grad grad { get; set; }
        //public DateTime vremeobjave{get;set;}
        public long resenaObjava { get; set; }
        public DateTime vreme { get; set; }
        public long LepaStvarID { get; set; }
        public virtual LepeStvari lepaStvar { get; set; }
        public bool Equals(Objave other)
        {
            if (other is null)
                return false;

            return this.id == other.id;
        }
        // public String satImin { get; set; }
        public override bool Equals(object obj) => Equals(obj as Objave);
        public override int GetHashCode() => (id).GetHashCode();
    }
}

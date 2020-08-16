using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.Models
{
    public class AzuriranjeKorisnika
    {
        public Korisnik korisnik { get; set; }
        public List<long> idGradova { get; set; }
        public string newPassword { get; set; }
      
    }
}

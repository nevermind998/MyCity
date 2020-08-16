using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface ILajkoviKomentaraDAL
    {
        List<LajkoviKomentara> getAllLajkovi();
        void saveLajk(LajkoviKomentara data);
        public void deleteLajkoveKomentara(List<LajkoviKomentara> lajkovi);
        public int getLajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara);


    }
}

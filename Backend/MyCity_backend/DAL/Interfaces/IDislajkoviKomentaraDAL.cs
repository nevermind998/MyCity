using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IDislajkoviKomentaraDAL
    {
        List<DislajkoviKomentari> getAllDislajkovi();
        void saveDislajk(DislajkoviKomentari data);
        void deleteDislajkKomentara(List<DislajkoviKomentari> dislajkovi);
        public int getDislajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara);
    }
}

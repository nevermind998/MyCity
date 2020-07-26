using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IDislajkoviBL
    {
        List<Dislajkovi> getAllDislajkovi();
        public void saveDislajk(Dislajkovi data);
        void deleteDislajkoveByIdObjave(long idObjave);
        void deleteDislajkoveByIdKorisnika(long idKorisnika);
        List<Dislajkovi> getDislajkoveByIdObjave(long idObjave);
        long getBrojDislajkovaByIdObjave(long idObjave);
        List<Dislajkovi> getDislajkoveByKorisnikId(long idKorisnika);
        List<Korisnik> getKorisnikeKojiDislajkujuByIdObjave(long idObjave);
        int getDislajkByKorisnikId(long idKorisnika, long idObjave);
    }
}

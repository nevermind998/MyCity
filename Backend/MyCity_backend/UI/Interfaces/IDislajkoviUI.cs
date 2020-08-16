using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface IDislajkoviUI
    {
        List<Dislajkovi> getAllDislajkovi();
        public void saveDislajk(Dislajkovi data);
        void deleteDislajkoveByIdObjave(long idObjave);
        void deleteDislajkoveByIdKorisnika(long idKorisnika);
        List<Dislajkovi> getDislajkoveByIdObjave(long idObjave);
        long getBrojDislajkovaByIdObjave(PrihvatanjeIdObjave data);
        List<Dislajkovi> getDislajkoveByKorisnikId(PrihvatanjeIdKorisnika data);
        List<KorisnikSaGradovima> getKorisnikeKojiDislajkujuByIdObjave(PrihvatanjeIdObjave objava);
        int getDislajkByKorisnikId(long idKorisnika, long idObjave);
    }
}

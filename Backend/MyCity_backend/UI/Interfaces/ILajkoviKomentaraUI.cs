using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface ILajkoviKomentaraUI
    {
        List<LajkoviKomentara> getAllLajkovi();
        void saveLajk(LajkoviKomentara data);
        void deleteLajkoveKomentaraByIdKomentara(long idKomentara);
        void deleteLajkoveKomentaraByIdKorisnika(long idKorisnika);
        List<LajkoviKomentara> getLajkoveKomentaraByIdKomentara(long idKomentara);
        long getBrojLajkovaByIdKomentara(long idKomentara);
        List<LajkoviKomentara> getLajkoveKomenatarByKorisnikId(PrihvatanjeIdKorisnika data);
        List<Korisnik> getKorisnikeKojiLajkujuByIdKomentara(long idKomentara);
        int getLajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara);
    }
}
